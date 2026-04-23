//
//  SleepDurationChart.swift
//  somnianalytics
//
//  Created by Leena Joulani on 4/22/26.
//

import SwiftUI
import Charts

struct SleepDurationEntry: Identifiable {
    let id = UUID()
    let day: String
    let hours: Double
}

struct SleepDurationChart: View {
    let data: [SleepDurationEntry]
    let avgHours: String

    private let purple = Color(red: 0.55, green: 0.35, blue: 0.95)

    @ChartContentBuilder
    private func barMark(for entry: SleepDurationEntry) -> some ChartContent {
        BarMark(
            x: .value("Day", entry.day),
            y: .value("Hours", entry.hours)
        )
        .foregroundStyle(purple)
        .cornerRadius(6)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Sleep Duration")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "moon.fill")
                        .font(.system(size: 12))
                        .foregroundColor(purple)
                    Text("\(avgHours) avg")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                }
            }

            Chart(data) { entry in
                barMark(for: entry)
            }
            .chartYAxis {
                AxisMarks(values: .stride(by: 2)) { value in
                    AxisGridLine()
                        .foregroundStyle(Color.white.opacity(0.1))
                    AxisValueLabel {
                        if let v = value.as(Int.self) {
                            Text("\(v)")
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
            .chartYAxisLabel(position: .leading) {
                Text("Hours")
                    .foregroundStyle(Color.white.opacity(0.8))
                    .font(.system(size: 11))
            }            .frame(height: 160)
        }
        .padding(16)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    
}
