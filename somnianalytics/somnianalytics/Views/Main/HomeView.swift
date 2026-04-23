//
//  HomeView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/27/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(Router.self) private var router
    @Environment(AlarmViewModel.self) private var alarmVM
    @Environment(AuthViewModel.self) private var authVM
    private let purple = Color(red: 0.55, green: 0.35, blue: 0.95)
    @State private var showModal: Bool = false
    // Mock data for now
    private let mockSleepStart = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date()) ?? Date()
    private let mockWakeUpTime = Calendar.current.date(bySettingHour: 6, minute: 42, second: 0, of: Date()) ?? Date()
    private let mockAlarmStart = Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date()) ?? Date()
    private let mockAlarmEnd = Calendar.current.date(bySettingHour: 6, minute: 45, second: 0, of: Date()) ?? Date()
    

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            RadialGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.2),
                    Color.clear
                ]),
                center: .top,
                startRadius: 10,
                endRadius: 500
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    header

                    WakeUpCard(
                        wakeUpTime: mockWakeUpTime,
                        sleepStage: "Light Sleep",
                        windowStart: mockAlarmStart,
                        windowEnd: mockAlarmEnd
                    )

                    NextAlarmCard(
                        alarmStart: alarmVM.earliestTime,
                        alarmEnd: alarmVM.latestTime,
                        isEnabled: alarmVM.alarmIsSet && alarmVM.alarmIsEnabled
                    )

                    SleepSummaryCard(
                        totalSleep: "7h 42m",
                        sleepStart: mockSleepStart,
                        sleepEnd: mockWakeUpTime
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .sheet(isPresented: $showModal) {
                settingsModal
            }
        }
    }

    
    // Top header with day and profile icon for now, will add date navigation later
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good Morning")
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.5))

                Text("Today")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()
            
            Button(action: {
                // TODO: Navigate to profile page
                showModal.toggle()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 40, height: 40)

                    Image(systemName: "person")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.top, 16)
    }
    
    private var settingsModal: some View {
        VStack(alignment: .center) {
            Text("User Settings")
                .font(.title)
                .fontWeight(.bold)
            
            Button(action: {
                authVM.authState = AuthState.unauthenticated
            }) {
                Text("Sign out")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(purple)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        
    }
}

#Preview {
    HomeView()
        .environment(Router(level: 0, identifierTab: .home))
}
