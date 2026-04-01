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
    
    // function that will be called to schedule single alarms, and we might make the payload for this more so that we maybe send an http request to the backend potentially also updating the alarm table?
    func scheduleSingleAlarm() async throws {
        try await scheduleAlarm(userId: 10)
    }
}
