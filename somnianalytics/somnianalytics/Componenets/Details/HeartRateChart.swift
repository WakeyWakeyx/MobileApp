//
//  HeartRateChart.swift
//  somnianalytics
//
//  Created by Leena Joulani on 4/21/26.
//

import SwiftUI
import Charts

// Data point for heart rate chart
struct HeartRatePoint: Identifiable {
    let id = UUID()
    let time: Date
    let bpm: Double
}

struct HeartRateChart: View {
    let data: [HeartRatePoint]
    let avgBPM: Int
    let restingBPM: Int

    private let purple = Color(red: 0.55, green: 0.35, blue: 0.95)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Chart(data) { point in
                LineMark(
                    x: .value("Time", point.time),
                    y: .value("BPM", point.bpm)
                )
                .foregroundStyle(Color.red.opacity(0.8))
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("Time", point.time),
                    y: .value("BPM", point.bpm)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.red.opacity(0.3), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 2)) { value in
                    AxisGridLine()
                        .foregroundStyle(Color.white.opacity(0.1))
                    AxisValueLabel(format: .dateTime.hour().minute())
                        .foregroundStyle(Color.white.opacity(0.8))
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.white.opacity(0.1))
                    AxisValueLabel()
                        .foregroundStyle(Color.white.opacity(0.8))
                }
            }
            .frame(height: 160)
            .padding(16)

            Divider()
                .background(Color.white.opacity(0.1))

            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 13))
                        .foregroundColor(Color.red.opacity(0.7))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Average HR")
                            .font(.system(size: 14))
                            .foregroundColor(Color.white.opacity(0.4))
                        Text("\(avgBPM) bpm")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                Spacer()

                Divider()
                    .frame(height: 30)
                    .background(Color.white.opacity(0.1))

                Spacer()

                HStack(spacing: 8) {
                    Image(systemName: "heart")
                        .font(.system(size: 13))
                        .foregroundColor(Color.white.opacity(0.4))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Resting HR")
                            .font(.system(size: 14))
                            .foregroundColor(Color.white.opacity(0.4))
                        Text("\(restingBPM) bpm")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(16)
        }
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    
}
