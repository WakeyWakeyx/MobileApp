//
//  AlarmView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/23/26.
//

import SwiftUI

struct AlarmView: View {
    @Environment(AlarmViewModel.self) var alarmVM
    @State private var earliestTime: Date = Date()
    @State private var latestTime: Date = Date()
    
    // computed value for the window minutes diff
    private var windowMinutes: Int {
        let diff = latestTime.timeIntervalSince(earliestTime)
        return max(Int(diff / 60), 0)
    }
    
    var body: some View {
        VStack {
            headerText
            
            timeWindowView
            
            datePickers
            
            alarmStatus
            
            scheduleAlarmButton
            
            Spacer()
            
        }
        .navigationTitle("Alarms")
        .navigationBarTitleDisplayMode(.large)
        .onAppear(perform: {
            Task{
                await alarmVM.requestAuthorization()
            }
        })
        .overlay {
            if alarmVM.isLoading {
                LoadingView()
            }
        }
    }
    
    
    private var alarmStatus: some View {
        Text("status: \(alarmVM.alarmAuthState.rawValue)")
            .font(.largeTitle)
            .padding()
            .foregroundStyle(.primary)
    }
    
    private var timeWindowView: some View {
        VStack(spacing: 12) {
            Text("Wake window")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack(alignment: .center, spacing: 20) {
                // Left time
                VStack {
                    Text(formattedTime(earliestTime))
                        .font(.system(size: 48, weight: .bold))
                    
                    Text(amPM(earliestTime))
                        .font(.title)
                        .fontWeight(.semibold)
                }
                
                Image(systemName: "arrow.right")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                
                VStack(spacing: 4) {
                    Text(formattedTime(latestTime))
                        .font(.system(size: 48, weight: .bold))
                    
                    Text(amPM(latestTime))
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
            
            Text(windowMinutes.description + " minutes")
                .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private var datePickers: some View {
        HStack {
            DatePicker(
                "Earliest",
                selection: $earliestTime,
                displayedComponents: .hourAndMinute
            )
            .padding(.horizontal)
            .labelsHidden()
            
            Spacer()
            
            DatePicker(
                "Latest",
                selection: $latestTime,
                displayedComponents: .hourAndMinute
            )
            .padding(.horizontal)
            .labelsHidden()
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
    
    private var scheduleAlarmButton: some View {
        Button("Set Alarm") {
            Task {
                await alarmVM.createAlarm()
            }
        }
    }
    
    
}

#Preview {
    AlarmView()
}
