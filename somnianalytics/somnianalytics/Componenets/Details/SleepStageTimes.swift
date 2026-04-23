//
//  SleepStageTimes.swift
//  somnianalytics
//
//  Created by Leena Joulani on 4/20/26.
//

import SwiftUI

struct SleepStageTimes: View {
    let stage: String        
    let duration: String
    let percentage: String

    private var stageColor: Color {
        switch stage.lowercased() {
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
            HStack(spacing: 6) {
                Circle()
                    .fill(stageColor)
                    .frame(width: 10, height: 10)
                Text(stage.uppercased())
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.white.opacity(0.6))
                    .tracking(1)
            }

            Text(duration)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            Text(percentage)
                .font(.system(size: 13))
                .foregroundColor(Color.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    
}
