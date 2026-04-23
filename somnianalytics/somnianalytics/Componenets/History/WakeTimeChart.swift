//
//  WakeTimeChart.swift
//  somnianalytics
//
//  Created by Leena Joulani on 4/22/26.
//

import SwiftUI
import Charts

struct WakeTimeEntry: Identifiable {
    let id = UUID()
    let day: String
    let hour: Double
}

struct WakeTimeChart: View {
    let data: [WakeTimeEntry]
    let avgWakeTime: String

    private let blue = Color(red: 0.29, green: 0.55, blue: 0.90)

    @ChartContentBuilder
    private func lineMark(for entry: WakeTimeEntry) -> some ChartContent {
        LineMark(
            x: .value("Day", entry.day),
            y: .value("Hour", entry.hour)
        )
        .foregroundStyle(blue)
        .lineStyle(StrokeStyle(lineWidth: 2))
        .interpolationMethod(.catmullRom)

        PointMark(
            x: .value("Day", entry.day),
            y: .value("Hour", entry.hour)
        )
        .foregroundStyle(blue)
        .symbolSize(40)
    }

    private func hourLabel(_ hour: Double) -> String {
        let h = Int(hour)
        let m = Int((hour - Double(h)) * 60)
        let ampm = h < 12 ? "AM" : "PM"
        let displayH = h > 12 ? h - 12 : h
        if m == 0 {
            return "\(displayH):00"
        }
        return "\(displayH):\(String(format: "%02d", m))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Wake Time")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "alarm.fill")
                        .font(.system(size: 12))
                        .foregroundColor(blue)
                    Text("\(avgWakeTime) avg")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                }
            }

            Chart(data) { entry in
                lineMark(for: entry)
            }
            .chartYAxis {
                AxisMarks(values: [5.0, 6.0, 7.0, 8.0, 9.0]) { value in
                    AxisGridLine()
                        .foregroundStyle(Color.white.opacity(0.1))
                    AxisValueLabel {
                        if let v = value.as(Double.self) {
                            Text(hourLabel(v))
                                .foregroundStyle(Color.white.opacity(0.8))
                                .font(.system(size: 11))
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .foregroundStyle(Color.white.opacity(0.8))
                }
            }
            .chartYScale(domain: 5.0...9.5)
            .frame(height: 160)
        }
        .padding(16)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {

}
