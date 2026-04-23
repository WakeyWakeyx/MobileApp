//
//  SharedAlarmStore.swift
//  somnianalytics
//
//

import AlarmKit
import Foundation

@MainActor
@Observable
final class SharedAlarmStore {
    static let shared = SharedAlarmStore()

    private let suiteName = "group.somnianalytics"
    private let runningKey = "somni.alarm.running"
    private let recentKey = "somni.alarm.recent"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let alarmManager = AlarmManager.shared

    var runningAlarms: [SharedAlarmSnapshot] = [] {
        didSet { persist(runningAlarms, forKey: runningKey) }
    }

    var recentAlarms: [SharedAlarmSnapshot] = [] {
        didSet { persist(recentAlarms, forKey: recentKey) }
    }

    private var defaults: UserDefaults {
        UserDefaults(suiteName: suiteName) ?? .standard
    }

    private init() {
        loadPersistedSnapshots()
        observeAlarmUpdates()
    }

    func loadPersistedSnapshots() {
        runningAlarms = loadSnapshots(forKey: runningKey)
        recentAlarms = loadSnapshots(forKey: recentKey)
    }

    func refreshRemoteAlarms() async {
        do {
            let remoteAlarms = try alarmManager.alarms
            mergeRemoteAlarms(remoteAlarms)
        } catch {
            print("refreshRemoteAlarms failed: \(error.localizedDescription)")
        }
    }

    func recordScheduledAlarm(_ alarm: Alarm, metadata: SomniAlarmMetadata) {
        let snapshot = SharedAlarmSnapshot(alarm: alarm, metadata: metadata)
        runningAlarms.removeAll(where: { $0.id == snapshot.id })
        recentAlarms.removeAll(where: { $0.id == snapshot.id })
        runningAlarms.insert(snapshot, at: 0)
    }

    func stopAlarm(id: UUID) throws {
        if let snapshot = runningAlarms.first(where: { $0.id == id }) {
            if snapshot.fireDate != nil {
                try alarmManager.cancel(id: id)
            } else {
                try alarmManager.stop(id: id)
            }

            moveToRecent(id: id, state: "stopped")
            return
        }

        throw AlarmErrors.alarmSchedulingError
    }

    func pauseAlarm(id: UUID) throws {
        try alarmManager.pause(id: id)
        updateRunningState(id: id, state: "paused")
    }

    func resumeAlarm(id: UUID) throws {
        try alarmManager.resume(id: id)
        updateRunningState(id: id, state: "countdown")
    }

    func repeatAlarm(id: UUID) throws {
        try alarmManager.countdown(id: id)
        updateRunningState(id: id, state: "countdown")
    }

    private func observeAlarmUpdates() {
        Task {
            for await remoteAlarms in alarmManager.alarmUpdates {
                await MainActor.run {
                    self.mergeRemoteAlarms(remoteAlarms)
                }
            }
        }
    }

    private func mergeRemoteAlarms(_ remoteAlarms: [Alarm]) {
        let localSnapshots = Dictionary(uniqueKeysWithValues: runningAlarms.map { ($0.id, $0) })
        let mergedRunning = remoteAlarms.map { alarm in
            if let localSnapshot = localSnapshots[alarm.id] {
                return SharedAlarmSnapshot(
                    id: alarm.id,
                    userId: localSnapshot.userId,
                    title: localSnapshot.title,
                    createdAt: localSnapshot.createdAt,
                    fireDate: alarm.somniFireDate(createdAt: localSnapshot.createdAt),
                    state: alarm.state.somniLabel
                )
            }

            let createdAt = Date()
            return SharedAlarmSnapshot(
                id: alarm.id,
                userId: 0,
                title: "Scheduled Alarm",
                createdAt: createdAt,
                fireDate: alarm.somniFireDate(createdAt: createdAt),
                state: alarm.state.somniLabel
            )
        }

        let remoteIDs = Set(remoteAlarms.map(\ .id))
        let removedSnapshots = runningAlarms.filter { !remoteIDs.contains($0.id) }
        for snapshot in removedSnapshots {
            moveSnapshotToRecent(snapshot, state: snapshot.state == "alerting" ? "alerted" : snapshot.state)
        }

        runningAlarms = mergedRunning.sorted { ($0.fireDate ?? .distantFuture) < ($1.fireDate ?? .distantFuture) }
    }

    private func moveToRecent(id: UUID, state: String) {
        guard let index = runningAlarms.firstIndex(where: { $0.id == id }) else { return }
        var snapshot = runningAlarms.remove(at: index)
        snapshot.state = state
        moveSnapshotToRecent(snapshot, state: state)
    }

    private func moveSnapshotToRecent(_ snapshot: SharedAlarmSnapshot, state: String) {
        var updated = snapshot
        updated.state = state
        recentAlarms.removeAll(where: { $0.id == updated.id })
        recentAlarms.insert(updated, at: 0)
    }

    private func updateRunningState(id: UUID, state: String) {
        guard let index = runningAlarms.firstIndex(where: { $0.id == id }) else { return }
        runningAlarms[index].state = state
    }

    private func loadSnapshots(forKey key: String) -> [SharedAlarmSnapshot] {
        guard let data = defaults.data(forKey: key) else { return [] }

        do {
            return try decoder.decode([SharedAlarmSnapshot].self, from: data)
        } catch {
            print("loadSnapshots failed for \(key): \(error.localizedDescription)")
            return []
        }
    }

    private func persist(_ snapshots: [SharedAlarmSnapshot], forKey key: String) {
        do {
            defaults.set(try encoder.encode(snapshots), forKey: key)
        } catch {
            print("persist snapshots failed for \(key): \(error.localizedDescription)")
        }
    }
}
