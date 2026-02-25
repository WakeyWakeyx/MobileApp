//
//  AlarmStates.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/24/26.
//

import Foundation
import AlarmKit

enum AlarmStates {
    case unAuthorized
    case authorized
    case unknown
}

/**
  Function to request alarm authorization from user
 */
func requestAuthorization() async throws {
    do {
        let manager = AlarmManager.shared //getting shared instance here
        let status = try await manager.requestAuthorization()
    } catch {
        // TODO: Might come back and make this more fledged out
        throw AlarmErrors.requestAuthorizationError
    }
}


func checkAuthorization() async -> AlarmStates {
    switch AlarmManager.shared.authorizationState {
    case .notDetermined:
        do {
            try await requestAuthorization()
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
