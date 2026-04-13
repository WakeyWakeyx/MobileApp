//
//  AlarmScheduler.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/24/26.
//

import Foundation
import AlarmKit
import SwiftUI

/**
  The alarm data that mimicks what the data on the backend will be expecting
 */
struct AlarmData: AlarmMetadata {
    let id: UUID // alarm id
    let userId: Int
    let alarmName: String
    let enabled: Bool // might not keep this
    
    init(id: UUID, userId: Int, alarmName: String, enabled: Bool ) {
        self.id = id
        self.userId = userId
        self.alarmName = alarmName
        self.enabled = enabled
    }
}


public func scheduleAlarm(userId: Int) async throws {
    typealias AlarmConfiguration = AlarmManager.AlarmConfiguration<AlarmData>
    
    let id = UUID() //alarm id
     
    // this is the button that is shown when the phone is not in the home section
    let stopButton = AlarmButton(
        text: "dismiss",
        textColor: .white,
        systemImageName: "stop.circle"
    )
    
    // alert presentation for when it pops up in the top of the screen
    let alertPresentation = AlarmPresentation.Alert(
        title: "Wake Up!",
        secondaryButton: stopButton
    )
    
    let attributes = AlarmAttributes<AlarmData>(
        presentation: AlarmPresentation(alert: alertPresentation),
        tintColor: .purple
    )
    let duration = Alarm.CountdownDuration(preAlert: (10 * 60), postAlert: (5 * 60))
    
    // setting the countdown as .none so that it will immediatlely fire the alarm off because we are wanting this to happen in real time
    let alarmConfiguration = AlarmConfiguration(countdownDuration: duration, attributes: attributes)
    do {
        try await AlarmManager.shared.schedule(id: id, configuration: alarmConfiguration)
    } catch  {
        print("alarm scheduling error: \(error)")
        throw error
    }
    
}
