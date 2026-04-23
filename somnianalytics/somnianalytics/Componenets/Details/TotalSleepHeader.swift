//
//  TotalSleepHeader.swift
//  somnianalytics
//
//  Created by Leena Joulani on 4/21/26.
//

import SwiftUI
 
struct TotalSleepHeader: View {
    let totalSleep: String
    let sleepStart: Date
    let sleepEnd: Date
 
    private let purple = Color(red: 0.55, green: 0.35, blue: 0.95)
 
    var body: some View {
        VStack(spacing: 8) {
            
            Text(totalSleep)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
 
            HStack(spacing: 8) {
                Text("\(formattedTime(sleepStart)) \(amPM(sleepStart))")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.6))
 
                Text("→")
                    .foregroundColor(Color.white.opacity(0.3))
 
                Text("\(formattedTime(sleepEnd)) \(amPM(sleepEnd))")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
 
#Preview {

}
