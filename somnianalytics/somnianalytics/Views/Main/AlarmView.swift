//
//  AlarmView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/23/26.
//

import SwiftUI

struct AlarmView: View {
    @Environment(AlarmViewModel.self) var alarmVM
    @Environment(SharedAlarmStore.self) var sharedAlarmStore
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

            scheduledAlarms
             
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
        VStack(spacing: 8) {
            Text("status: \(alarmVM.alarmAuthState.rawValue)")
                .font(.title2)
                .foregroundStyle(.primary)

            Text("scheduled alarms: \(sharedAlarmStore.runningAlarms.count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
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
                await alarmVM.createAlarm(at: latestTime)
            }
        }
        .buttonStyle(.borderedProminent)
        .padding(.top, 8)
    }

    private var scheduledAlarms: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Scheduled in Somni")
                .font(.headline)

            if sharedAlarmStore.runningAlarms.isEmpty {
                Text("No alarms scheduled yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(sharedAlarmStore.runningAlarms) { alarm in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(alarm.title)
                            .font(.body.weight(.semibold))
                        if let fireDate = alarm.fireDate {
                            Text(fireDate.formatted(date: .omitted, time: .shortened))
                                .foregroundStyle(.secondary)
                        }
                        Text(alarm.state)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6).opacity(0.5))
                    )
                }
            }
        }
        .padding(.horizontal)
    }
    
    
}

#Preview {
    AlarmView()
}
