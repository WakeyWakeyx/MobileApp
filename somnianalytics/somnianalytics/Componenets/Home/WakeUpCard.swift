//
//  WakeUpCard.swift
//  somnianalytics
//
//  Created by Leena Joulani on 3/5/26.
//

import SwiftUI

struct WakeUpCard: View {
    @Environment(Router.self) private var router

    let wakeUpTime: Date
    let sleepStage: String
    let windowStart: Date
    let windowEnd: Date

    private let purple = Color(red: 0.55, green: 0.35, blue: 0.95)

    // Formats a Date into a readable time string like "6:30 AM"
    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()

    var body: some View {
        VStack(spacing: 16) {
            wakeUpSection
            Divider()
                .background(Color.white.opacity(0.1))
            alarmWindowSection
        }
        .padding(20)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    // Top section - wake up time and sleep stage badge
    private var wakeUpSection: some View {
        VStack(spacing: 12) {
            Text("You woke up at")
                .font(.system(size: 20))
                .foregroundColor(Color.white.opacity(0.6))

            HStack(spacing: 8) {
                Image(systemName: "alarm")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(purple)

                Text(timeFormatter.string(from: wakeUpTime))
                    .font(.system(size: 45, weight: .bold))
                    .foregroundColor(purple)
            }

            SleepStageBadge(stage: sleepStage)
        }
    }

    // Bottom section - alarm window range
    private var alarmWindowSection: some View {
        VStack(spacing: 8) {
            Text("Alarm Window")
                .font(.system(size: 13))
                .foregroundColor(Color.white.opacity(0.6))

            HStack(spacing: 12) {
                Text(timeFormatter.string(from: windowStart))
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)

                Rectangle()
                    .frame(width: 15, height: 1)
                    .foregroundColor(Color.white.opacity(0.5))

                Text(timeFormatter.string(from: windowEnd))
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// Badge to display what stage user woke up in
private struct SleepStageBadge: View {
    let stage: String

    // Colors match the sleep stage chart in the dashboard page
    private var stageColor: Color {
        switch stage.lowercased() {
        case "light sleep":
            return Color(red: 0.29, green: 0.45, blue: 0.60)
        case "deep sleep":
            return Color(red: 0.13, green: 0.37, blue: 0.27)
        case "rem":
            return Color(red: 0.50, green: 0.30, blue: 0.42)
        case "awake":
            return Color(red: 0.48, green: 0.42, blue: 0.15)
        default:
            return Color(red: 0.55, green: 0.35, blue: 0.95)
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(stageColor)
                .frame(width: 8, height: 8)

            Text(stage)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(stageColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(stageColor.opacity(0.25))
        .clipShape(Capsule())
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 16) {
            WakeUpCard(
                wakeUpTime: Calendar.current.date(bySettingHour: 6, minute: 42, second: 0, of: Date()) ?? Date(),
                sleepStage: "Light Sleep",
                windowStart: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date()) ?? Date(),
                windowEnd: Calendar.current.date(bySettingHour: 6, minute: 45, second: 0, of: Date()) ?? Date()
            )
        }
        .padding()
        .environment(Router(level: 0, identifierTab: .home))
    }
}
