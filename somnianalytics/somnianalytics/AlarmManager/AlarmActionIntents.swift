//
//  AlarmActionIntents.swift
//  somnianalytics
//
//  Created by OpenCode on 4/13/26.
//

import AppIntents
import Foundation

struct StopAlarmIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Stop Alarm"
    static var description = IntentDescription("Stop the currently alerting alarm.")

    @Parameter(title: "Alarm ID")
    var alarmID: String

    init(alarmID: UUID) {
        self.alarmID = alarmID.uuidString
    }

    init() {
        self.alarmID = ""
    }

    func perform() throws -> some IntentResult {
        guard let id = UUID(uuidString: alarmID) else {
            throw AlarmErrors.alarmSchedulingError
        }

        Task { @MainActor in
            try SharedAlarmStore.shared.stopAlarm(id: id)
        }

        return .result()
    }
}

struct PauseAlarmIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Pause Alarm"
    static var description = IntentDescription("Pause the current countdown.")

    @Parameter(title: "Alarm ID")
    var alarmID: String

    init(alarmID: UUID) {
        self.alarmID = alarmID.uuidString
    }

    init() {
        self.alarmID = ""
    }

    func perform() throws -> some IntentResult {
        guard let id = UUID(uuidString: alarmID) else {
            throw AlarmErrors.alarmSchedulingError
        }

        Task { @MainActor in
            try SharedAlarmStore.shared.pauseAlarm(id: id)
        }

        return .result()
    }
}

struct ResumeAlarmIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Resume Alarm"
    static var description = IntentDescription("Resume the paused countdown.")

    @Parameter(title: "Alarm ID")
    var alarmID: String

    init(alarmID: UUID) {
        self.alarmID = alarmID.uuidString
    }

    init() {
        self.alarmID = ""
    }

    func perform() throws -> some IntentResult {
        guard let id = UUID(uuidString: alarmID) else {
            throw AlarmErrors.alarmSchedulingError
        }

        Task { @MainActor in
            try SharedAlarmStore.shared.resumeAlarm(id: id)
        }

        return .result()
    }
}

struct RepeatAlarmIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Repeat Alarm"
    static var description = IntentDescription("Trigger the alarm countdown again.")

    @Parameter(title: "Alarm ID")
    var alarmID: String

    init(alarmID: UUID) {
        self.alarmID = alarmID.uuidString
    }

    init() {
        self.alarmID = ""
    }

    func perform() throws -> some IntentResult {
        guard let id = UUID(uuidString: alarmID) else {
            throw AlarmErrors.alarmSchedulingError
        }

        Task { @MainActor in
            try SharedAlarmStore.shared.repeatAlarm(id: id)
        }

        return .result()
    }
}
