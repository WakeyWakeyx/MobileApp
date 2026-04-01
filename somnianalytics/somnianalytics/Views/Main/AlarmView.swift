//
//  AlarmView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/23/26.
//

import SwiftUI

struct AlarmView: View {
    @Environment(AlarmService.self) var alarmService
    @State private var earliestTime: Date = Date()
    @State private var latestTime: Date = Date()
    
    
    let calendar = Calendar.current
    var intervalNew = calendar.dateComponents([.hour, .minute], from: latestTime, to: earliestTime)
    var body: some View {
        VStack {
            headerText
            
            timeWindowView
            
            alarmStatus
            
            Spacer()
            
        }
        .navigationTitle("Alarms")
        .navigationBarTitleDisplayMode(.large)
        .onAppear(perform: {
            Task{
                await alarmService.requestAuthorization()
            }
        })
    }
    
    
    private var alarmStatus: some View {
        Text("status: \(alarmService.alarmAuthState.rawValue)")
            .font(.largeTitle)
            .padding()
            .foregroundStyle(.primary)
    }
    
    private var timeWindowView: some View {
        VStack {
            HStack {
                DatePicker(
                    "Earliest",
                    selection: $earliestTime,
                    displayedComponents: .hourAndMinute
                )
                .padding(.horizontal)
                
                Spacer()
                
                DatePicker(
                    "Latest",
                    selection: $latestTime,
                    displayedComponents: .hourAndMinute
                )
                .padding(.horizontal)
            }
            .padding()
            
            Text(\(latestTime.timeIntervalSince(earliestTime)))
                .padding()
        }
        
    }
    
    private var headerText: some View {
        Text("Choose a time range for waking up. You'll be woken when you're in the lightest sleep stage during that window, helping you feel more refreshed.")
            .padding()
            .multilineTextAlignment(.center)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6).opacity(0.4))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1) // subtle border
            )
            .padding(.horizontal)
    }
    
    
}

#Preview {
    AlarmView()
}
