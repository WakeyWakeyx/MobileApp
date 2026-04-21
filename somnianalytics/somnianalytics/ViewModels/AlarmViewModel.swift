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
    
    // default values until user changes values 
    var earliestTime: Date = Calendar.current.date(bySettingHour: 6, minute: 15, second: 0, of: Date()) ?? Date()
    var latestTime: Date = Calendar.current.date(bySettingHour: 6, minute: 45, second: 0, of: Date()) ?? Date()
    var alarmIsEnabled: Bool = false
    var alarmIsSet: Bool = false
    
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
