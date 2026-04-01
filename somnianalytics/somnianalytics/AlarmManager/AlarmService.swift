//
//  AlarmService.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/26/26.
//

import Foundation
import AlarmKit

@Observable
final class AlarmService {
    var alarmAuthState: AlarmStates = AlarmStates.unknown
    var alarms: [Alarm] = []
    var isLoading: Bool = false
    let alarmEngine = AlarmEngine()
    
    func loadAlarms() async throws {
        do {
            // in here would call a method to load the alarms from the user's storage
            
        } catch {
            
        }
    }
    
    /**
        Method to request the alarm state from the user.
     */
    func requestAuthorization() async {
        alarmAuthState = await alarmEngine.checkAuthorization()
    }
    
    /**
     Method for creating an alarm
     */
    func createAlarm() async {
        do {
            isLoading = true
            try await alarmEngine.scheduleSingleAlarm()
            print("Alarm created")
            isLoading = false
        } catch {
            print(error)
            isLoading = false
            
        }
    }
    
}
