//
//  AlarmEngine.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/26/26.
//

import Foundation
import AlarmKit


/**
    This file is going to be the logic (no UI) for the alarm management system in the app
 */

actor AlarmEngine {
    private var lastFireDate: Date?
    private var lastAlarmID: UUID?
    private let alarmManager = AlarmManager.shared
    
    
    /**
      Function to request alarm authorization from user
     */
    func requestAuthorization() async throws -> AlarmManager.AuthorizationState {
        do {
            let manager = AlarmManager.shared //getting shared instance here
            let status = try await manager.requestAuthorization()
            return status
        } catch {
            // TODO: Might come back and make this more fledged out
            throw AlarmErrors.requestAuthorizationError
        }
    }
    
    // function to check authorization state
    func checkAuthorization() async -> AlarmStates {
        switch AlarmManager.shared.authorizationState {
        case .notDetermined:
            do {
                let status = try await requestAuthorization()
                if status == AlarmManager.AuthorizationState.authorized {
                    return AlarmStates.authorized
                }
                return AlarmStates.unAuthorized
            } catch {
                return AlarmStates.unAuthorized
            }
        case .denied:
            return AlarmStates.unAuthorized // will handle this in the ui
        case .authorized:
            return AlarmStates.authorized
        @unknown default:
            return AlarmStates.unknown
        }
    }
    
    
    // function to observe any state changes for the authorization state
    private func observeAuthorizationUpdates() {
        Task {
            for await _ in alarmManager.authorizationUpdates {
                await self.checkAuthorization()
            }
        }
    }
    
    private func nextOccurrence(for selectedDate: Date) -> Date {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .minute], from: selectedDate)

        guard let candidate = calendar.nextDate(
            after: now,
            matching: components,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .forward
        ) else {
            return selectedDate > now ? selectedDate : now.addingTimeInterval(60)
        }

        return candidate
    }

    private func ensureAuthorized() async throws {
        let status = await checkAuthorization()
        guard status == .authorized else {
            throw AlarmErrors.requestAuthorizationError
        }
    }
    
    // function that will be called to schedule single alarms, and we might make the payload for this more so that we maybe send an http request to the backend potentially also updating the alarm table?
    func scheduleSingleAlarm(at selectedDate: Date) async throws {
        try await ensureAuthorized()

        let fireDate = nextOccurrence(for: selectedDate)
        lastFireDate = fireDate
        let metadata = SomniAlarmMetadata(id: UUID(), userId: 10, title: "Wake Up", createdAt: Date())
        let alarm = try await scheduleAlarm(metadata: metadata, fireDate: fireDate)

        lastAlarmID = alarm.id

        await MainActor.run {
            SharedAlarmStore.shared.recordScheduledAlarm(alarm, metadata: metadata)
        }
    }
}
