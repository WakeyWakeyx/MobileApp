//
//  SomniAlarmMetadata.swift
//  AlarmLiveActivity
//
//  Created by OpenCode on 4/13/26.
//

import AlarmKit
import Foundation

nonisolated struct SomniAlarmMetadata: AlarmMetadata, Codable, Hashable, Sendable {
    var id: UUID
    var userId: Int
    var title: String
    var createdAt: Date

    init(id: UUID, userId: Int, title: String, createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.title = title
        self.createdAt = createdAt
    }
}

struct SharedAlarmSnapshot: Codable, Hashable, Identifiable, Sendable {
    var id: UUID
    var userId: Int
    var title: String
    var createdAt: Date
    var fireDate: Date?
    var state: String
}

enum SharedAlarmSnapshotStore {
    private static let suiteName = "group.somnianalytics"
    private static let runningKey = "somni.alarm.running"
    private static let recentKey = "somni.alarm.recent"

    static func snapshot(for alarmID: UUID) -> SharedAlarmSnapshot? {
        let snapshots = loadSnapshots(forKey: runningKey) + loadSnapshots(forKey: recentKey)
        return snapshots.first(where: { $0.id == alarmID })
    }

    private static func loadSnapshots(forKey key: String) -> [SharedAlarmSnapshot] {
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        guard let data = defaults.data(forKey: key) else { return [] }

        return (try? JSONDecoder().decode([SharedAlarmSnapshot].self, from: data)) ?? []
    }
}
