//
//  HistoryView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/23/26.
//

import SwiftUI

struct HistoryView: View {

    // Mock sleep duration data
    private let mockDurationData: [SleepDurationEntry] = [
        SleepDurationEntry(day: "Mon", hours: 7.5),
        SleepDurationEntry(day: "Tue", hours: 8.2),
        SleepDurationEntry(day: "Wed", hours: 7.8),
        SleepDurationEntry(day: "Thu", hours: 7.9),
        SleepDurationEntry(day: "Fri", hours: 6.0),
        SleepDurationEntry(day: "Sat", hours: 8.5),
        SleepDurationEntry(day: "Sun", hours: 7.2),
    ]

    // Mock wake time data
    private let mockWakeTimeData: [WakeTimeEntry] = [
        WakeTimeEntry(day: "Mon", hour: 6.5),
        WakeTimeEntry(day: "Tue", hour: 6.75),
        WakeTimeEntry(day: "Wed", hour: 6.25),
        WakeTimeEntry(day: "Thu", hour: 7.0),
        WakeTimeEntry(day: "Fri", hour: 6.0),
        WakeTimeEntry(day: "Sat", hour: 8.25),
        WakeTimeEntry(day: "Sun", hour: 7.33),
    ]

    // Mock daily breakdown data
    private let mockDailyBreakdown: [DailyBreakdownEntry] = [
        DailyBreakdownEntry(day: "Sun", wakeTime: "7:20 AM", duration: "7.2h", wokeIn: "REM"),
        DailyBreakdownEntry(day: "Sat", wakeTime: "8:15 AM", duration: "8.5h", wokeIn: "Light"),
        DailyBreakdownEntry(day: "Fri", wakeTime: "6:05 AM", duration: "7.7h", wokeIn: "Light"),
        DailyBreakdownEntry(day: "Thu", wakeTime: "7:10 AM", duration: "7.9h", wokeIn: "Deep"),
        DailyBreakdownEntry(day: "Wed", wakeTime: "6:15 AM", duration: "6.8h", wokeIn: "REM"),
        DailyBreakdownEntry(day: "Tue", wakeTime: "6:45 AM", duration: "8.2h", wokeIn: "Light"),
        DailyBreakdownEntry(day: "Mon", wakeTime: "6:30 AM", duration: "7.5h", wokeIn: "Light"),
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            RadialGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.3),
                    Color.clear
                ]),
                center: .top,
                startRadius: 10,
                endRadius: 500
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color.white.opacity(0.6))
                                .padding(10)
                                .background(Color.white.opacity(0.07))
                                .clipShape(Circle())
                        }

                        Spacer()

                        Text("Last 7 Days")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)

                        Spacer()

                        Button(action: {}) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.white.opacity(0.6))
                                .padding(10)
                                .background(Color.white.opacity(0.07))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 16)

                    Text("Sleep History")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)

                    SleepDurationChart(
                        data: mockDurationData,
                        avgHours: "7h 45m"
                    )

                    WakeTimeChart(
                        data: mockWakeTimeData,
                        avgWakeTime: "6:55 AM"
                    )

                    Text("Daily Breakdown")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    ForEach(mockDailyBreakdown) { entry in
                        DailyBreakdownRow(entry: entry)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
    }
}

#Preview {
    HistoryView()
}
