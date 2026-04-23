//
//  DetailsView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/23/26.
//

import SwiftUI

struct DetailsView: View {
    
    // Mock sleep start and sleep end data
    private let mockSleepStart = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date()) ?? Date()
    private let mockSleepEnd = Calendar.current.date(bySettingHour: 6, minute: 42, second: 0, of: Date()) ?? Date()

    // Mock heart rate chart data points
    private let mockHeartRateData: [HeartRatePoint] = {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today

        func timeToday(_ hour: Int, _ minute: Int) -> Date {
            calendar.date(bySettingHour: hour, minute: minute, second: 0, of: today) ?? today
        }

        func timeTomorrow(_ hour: Int, _ minute: Int) -> Date {
            calendar.date(bySettingHour: hour, minute: minute, second: 0, of: tomorrow) ?? tomorrow
        }

        return [
            HeartRatePoint(time: timeToday(23, 0), bpm: 68),
            HeartRatePoint(time: timeToday(23, 40), bpm: 55),
            HeartRatePoint(time: timeToday(23, 59), bpm: 62),
            HeartRatePoint(time: timeTomorrow(1, 20), bpm: 50),
            HeartRatePoint(time: timeTomorrow(2, 0), bpm: 58),
            HeartRatePoint(time: timeTomorrow(3, 0), bpm: 49),
            HeartRatePoint(time: timeTomorrow(4, 0), bpm: 63),
            HeartRatePoint(time: timeTomorrow(5, 0), bpm: 57),
            HeartRatePoint(time: timeTomorrow(6, 42), bpm: 72)
        ]
    }()

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
                    Text("Sleep Details")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 16)

                    Text("Total Sleep")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    TotalSleepHeader(
                        totalSleep: "7h 42m",
                        sleepStart: mockSleepStart,
                        sleepEnd: mockSleepEnd
                    )

                    Text("Time in Each Stage")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        SleepStageTimes(stage: "Light", duration: "4h 10m", percentage: "54% of sleep")
                        SleepStageTimes(stage: "Deep", duration: "1h 23m", percentage: "18% of sleep")
                        SleepStageTimes(stage: "REM", duration: "2h 18m", percentage: "30% of sleep")
                        SleepStageTimes(stage: "Awake", duration: "12m", percentage: "3% of sleep")
                    }

                    Text("Heart Rate")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    HeartRateChart(
                        data: mockHeartRateData,
                        avgBPM: 57,
                        restingBPM: 45
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
    }
}

#Preview {
    DetailsView()
}
