//
//  AlarmScheduler.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/24/26.
//

import Foundation
import AlarmKit
import ActivityKit
import SwiftUI

/**
  The alarm data that mimicks what the data on the backend will be expecting
 */
func scheduleAlarm(metadata: SomniAlarmMetadata, fireDate: Date) async throws -> Alarm {
    typealias AlarmConfiguration = AlarmManager.AlarmConfiguration<SomniAlarmMetadata>

    let schedule = Alarm.Schedule.fixed(fireDate)
    let id = metadata.id

    // this is the button that is shown when the phone is not in the home section
    let stopButton = AlarmButton(
        text: "Stop",
        textColor: .white,
        systemImageName: "stop.circle"
    )
    
    // alert presentation for when it pops up in the top of the screen
    let alertPresentation = AlarmPresentation.Alert(
        title: LocalizedStringResource(stringLiteral: metadata.title),
        stopButton: stopButton
    )
    
    let attributes = AlarmAttributes<SomniAlarmMetadata>(
        presentation: AlarmPresentation(alert: alertPresentation),
        metadata: metadata,
        tintColor: .purple
    )
    
    let alarmConfiguration = AlarmManager.AlarmConfiguration.alarm(
        schedule: schedule,
        attributes: attributes,
        stopIntent: StopAlarmIntent(alarmID: id),
        sound: .default
    )
    
    return try await AlarmManager.shared.schedule(id: id, configuration: alarmConfiguration)
}
