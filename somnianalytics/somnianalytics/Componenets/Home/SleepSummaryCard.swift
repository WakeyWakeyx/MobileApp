//
//  SleepSummaryCard.swift
//  somnianalytics
//
//  Created by Leena Joulani on 3/15/26.
//

import SwiftUI

struct SleepSummaryCard: View {
    @Environment(Router.self) private var router

    let totalSleep: String
    let sleepStart: Date
    let sleepEnd: Date

    private let purple = Color(red: 0.55, green: 0.35, blue: 0.95)

    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sleep Summary")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(purple.opacity(0.2))
                            .frame(width: 48, height: 48)

                        Image(systemName: "moon.fill")
                            .font(.system(size: 20))
                            .foregroundColor(purple)
                    }

                    // Total sleep label and duration on the left
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Sleep")
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.7))

                        Text(totalSleep)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    // Sleep start and end times on the right
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(timeFormatter.string(from: sleepStart))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)

                        Text("to")
                            .font(.system(size: 12))
                            .foregroundColor(Color.white.opacity(0.5))

                        Text(timeFormatter.string(from: sleepEnd))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                Divider()
                    .background(Color.white.opacity(0.15))

                Button(action: {
                    router.navigate(to: .tab(.details))
                }) {
                    Text("View sleep stages breakdown")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(purple)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(20)
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        SleepSummaryCard(
            totalSleep: "7h 42m",
            sleepStart: Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date()) ?? Date(),
            sleepEnd: Calendar.current.date(bySettingHour: 6, minute: 42, second: 0, of: Date()) ?? Date()
        )
        .padding()
        .environment(Router(level: 0, identifierTab: .home))
    }
}
