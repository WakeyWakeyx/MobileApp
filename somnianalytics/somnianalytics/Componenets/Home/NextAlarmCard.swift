//
//  NextAlarmCard.swift
//  somnianalytics
//
//  Created by Leena Joulani on 3/15/26.
//

import SwiftUI
 
struct NextAlarmCard: View {
    @Environment(Router.self) private var router
 
    let alarmStart: Date
    let alarmEnd: Date
    let isEnabled: Bool
 
    private let purple = Color(red: 0.55, green: 0.35, blue: 0.95)
 
    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()
 
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tonight's Alarm")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
 
            Button(action: {
                router.navigate(to: .tab(.alarm))
            }) {
                // Show different card layout based on alarm state
                if isEnabled {
                    alarmOnCard
                } else {
                    alarmOffCard
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
 
    // Card shown when alarm is enabled
    private var alarmOnCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                alarmIcon
                Text("Alarm is on")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                chevron
            }
 
            // Wake window sub card
            VStack(spacing: 6) {
                Text("Wake Window")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.7))
                
                HStack(spacing: 10) {
                    Text(timeFormatter.string(from: alarmStart))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(purple)
 
                    Rectangle()
                        .frame(width: 15, height: 1)
                        .foregroundColor(Color.white.opacity(0.6))
 
                    Text(timeFormatter.string(from: alarmEnd))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(purple)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(14)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(16)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
 
    // Card shown when alarm is disabled
    private var alarmOffCard: some View {
        HStack(spacing: 12) {
            alarmIcon
            VStack(alignment: .leading, spacing: 2) {
                Text("Alarm is off")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.white.opacity(0.3))
                Text("Turn on in Alarm settings")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.4))
            }
            Spacer()
            chevron
        }
        .padding(16)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
 
    // Reusable alarm icon that changes based on isEnabled
    private var alarmIcon: some View {
        ZStack {
            Circle()
                .fill(purple.opacity(0.2))
                .frame(width: 44, height: 44)
            Image(systemName: isEnabled ? "alarm.fill" : "alarm")
                .font(.system(size: 18))
                .foregroundColor(isEnabled ? purple : Color.white.opacity(0.3))
        }
    }
 
    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 13))
            .foregroundColor(Color.white.opacity(0.3))
    }
}
 
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
 
        VStack(spacing: 16) {
            // Alarm on
            NextAlarmCard(
                alarmStart: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date()) ?? Date(),
                alarmEnd: Calendar.current.date(bySettingHour: 6, minute: 45, second: 0, of: Date()) ?? Date(),
                isEnabled: true
            )
 
            // Alarm off
            NextAlarmCard(
                alarmStart: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date()) ?? Date(),
                alarmEnd: Calendar.current.date(bySettingHour: 6, minute: 45, second: 0, of: Date()) ?? Date(),
                isEnabled: false
            )
        }
        .padding()
        .environment(Router(level: 0, identifierTab: .home))
    }
}
 
