//
//  AlarmLiveActivityLiveActivity.swift
//  AlarmLiveActivity
//
//  Created by Hayden Barogh on 4/13/26.
//

import ActivityKit
import AlarmKit
import WidgetKit
import SwiftUI

struct AlarmLiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmAttributes<SomniAlarmMetadata>.self) { context in
            let snapshot = SharedAlarmSnapshotStore.snapshot(for: context.state.alarmID)
            let title = context.attributes.metadata?.title ?? snapshot?.title ?? "Alarm"

            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)

                if let fireDate = snapshot?.fireDate {
                    Text(fireDate, style: .time)
                        .font(.title2.monospacedDigit())
                }

                Text(modeLabel(for: context.state.mode))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .activityBackgroundTint(.purple.opacity(0.2))
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            let snapshot = SharedAlarmSnapshotStore.snapshot(for: context.state.alarmID)
            let title = context.attributes.metadata?.title ?? snapshot?.title ?? "Alarm"

            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "alarm.fill")
                        .foregroundStyle(.purple)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    Text(modeLabel(for: context.state.mode))
                        .font(.caption)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)

                        if let fireDate = snapshot?.fireDate {
                            Text(fireDate, style: .time)
                                .font(.body.monospacedDigit())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } compactLeading: {
                Image(systemName: "alarm.fill")
            } compactTrailing: {
                if let fireDate = snapshot?.fireDate {
                    Text(fireDate, style: .time)
                        .monospacedDigit()
                } else {
                    Text("Alarm")
                }
            } minimal: {
                Image(systemName: "alarm")
            }
        }
    }
}

private func modeLabel(for mode: AlarmPresentationState.Mode) -> String {
    switch mode {
    case .alert:
        return "Alerting"
    case .countdown:
        return "Counting down"
    case .paused:
        return "Paused"
    @unknown default:
        return "Alarm"
    }
}

#Preview("Notification", as: .content, using: AlarmAttributes<SomniAlarmMetadata>(presentation: AlarmPresentation(alert: .init(title: "Wake Up")), metadata: SomniAlarmMetadata(id: UUID(), userId: 10, title: "Wake Up"), tintColor: .purple)) {
   AlarmLiveActivityLiveActivity()
} contentStates: {
    AlarmPresentationState(alarmID: UUID(), mode: .alert(.init(time: .init(hour: 7, minute: 30))))
}
