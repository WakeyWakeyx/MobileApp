//
//  SomniAlarmMetadata.swift
//  somnianalytics
//
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

    init(id: UUID, userId: Int, title: String, createdAt: Date, fireDate: Date?, state: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.createdAt = createdAt
        self.fireDate = fireDate
        self.state = state
    }

    init(alarm: Alarm, metadata: SomniAlarmMetadata) {
        self.id = alarm.id
        self.userId = metadata.userId
        self.title = metadata.title
        self.createdAt = metadata.createdAt
        self.fireDate = alarm.somniFireDate(createdAt: metadata.createdAt)
        self.state = alarm.state.somniLabel
    }
}

extension Alarm {
    func somniFireDate(createdAt: Date) -> Date? {
        guard let schedule else { return nil }

        switch schedule {
        case .fixed(let date):
            return date
        case .relative(let relative):
            var components = Calendar.current.dateComponents([.year, .month, .day], from: createdAt)
            components.hour = relative.time.hour
            components.minute = relative.time.minute

            guard let candidate = Calendar.current.date(from: components) else {
                return nil
            }

            return candidate >= createdAt ? candidate : Calendar.current.date(byAdding: .day, value: 1, to: candidate)
        @unknown default:
            return nil
        }
    }
}

extension Alarm.State {
    var somniLabel: String {
        switch self {
        case .scheduled:
            return "scheduled"
        case .countdown:
            return "countdown"
        case .paused:
            return "paused"
        case .alerting:
            return "alerting"
        @unknown default:
            return "unknown"
        }
    }
}
