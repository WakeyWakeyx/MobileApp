//
//  DailyBreakdown.swift
//  somnianalytics
//
//  Created by Leena Joulani on 4/22/26.
//

import SwiftUI

struct DailyBreakdownEntry: Identifiable {
    let id = UUID()
    let day: String
    let wakeTime: String
    let duration: String
    let wokeIn: String
}

struct DailyBreakdownRow: View {
    let entry: DailyBreakdownEntry

    private var stageColor: Color {
        switch entry.wokeIn.lowercased() {
        case "light":
            return Color(red: 0.29, green: 0.45, blue: 0.60)
        case "deep":
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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.day)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Text("Woke in \(entry.wokeIn)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(stageColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(stageColor.opacity(0.15))
                    .clipShape(Capsule())
            }

            HStack(spacing: 4) {
                Text("Wake Time:")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                Text(entry.wakeTime)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)

                Text("|")
                    .foregroundColor(Color.white.opacity(0.3))
                    .padding(.horizontal, 4)

                Text("Duration:")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                Text(entry.duration)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    
}
