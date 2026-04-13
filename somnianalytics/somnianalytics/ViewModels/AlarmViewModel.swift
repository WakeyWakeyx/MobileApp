//
//  AlarmService.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/26/26.
//

import Foundation
import AlarmKit

@Observable
final class AlarmViewModel {
    var alarmAuthState: AlarmStates = AlarmStates.unknown
    var isLoading: Bool = false
    let alarmEngine = AlarmEngine()
    let sharedAlarmStore = SharedAlarmStore.shared
    
    func loadAlarms() async {
        await sharedAlarmStore.refreshRemoteAlarms()
    }
    
    /**
        Method to request the alarm state from the user.
     */
    func requestAuthorization() async {
        alarmAuthState = await alarmEngine.checkAuthorization()
        await loadAlarms()
    }
    
    /**
     Method for creating an alarm
     */
    func createAlarm(at selectedDate: Date) async {
        do {
            isLoading = true
            try await alarmEngine.scheduleSingleAlarm(at: selectedDate)
            await loadAlarms()
            print("Alarm created")
            isLoading = false
        } catch {
            print(error.localizedDescription)
            isLoading = false
            
        }
    }
    
}
