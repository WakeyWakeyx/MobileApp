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
    @State private var showEarliestPicker = false
    @State private var showLatestPicker = false

    @State private var monday = true
    @State private var tuesday = true
    @State private var wednesday = true
    @State private var thursday = true
    @State private var friday = true
    @State private var saturday = false
    @State private var sunday = false

    private let purple = Color(red: 0.55, green: 0.35, blue: 0.95)

    // computed value for the window minutes diff
    private var windowMinutes: Int {
        let diff = alarmVM.latestTime.timeIntervalSince(alarmVM.earliestTime)
        return max(Int(diff / 60), 0)
    }

    private var repeatLabel: String {
        let days = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        let weekdays = [monday, tuesday, wednesday, thursday, friday]
        let weekend = [saturday, sunday]

        if days.allSatisfy({ $0 }) { return "Every Day" }
        if weekdays.allSatisfy({ $0 }) && weekend.allSatisfy({ !$0 }) { return "Weekdays" }
        if weekend.allSatisfy({ $0 }) && weekdays.allSatisfy({ !$0 }) { return "Weekends" }
        if days.allSatisfy({ !$0 }) { return "Never" }
        return "Custom"
    }

    private func dismissPickers() {
        showEarliestPicker = false
        showLatestPicker = false
    }

    var body: some View {
        @Bindable var vm = alarmVM
        ZStack {
            Color.black.ignoresSafeArea()

            RadialGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.3),
                    Color.clear
                ]),
                center: .top,
                startRadius: 10,
                endRadius: 500
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    header(isEnabled: $vm.alarmIsEnabled)

                    if alarmVM.alarmIsEnabled {
                        bellIcon
                        headerText

                        if alarmVM.alarmIsSet {
                            alarmConfirmationCard
                            editAlarmButton
                        } else {
                            timeWindowView(earliestBinding: $vm.earliestTime, latestBinding: $vm.latestTime)
                            scheduleAlarmButton
                        }

                        repeatSection

                    } else {
                        alarmOffView
                    }

                    Spacer(minLength: 32)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .onAppear {
            Task {
                await alarmVM.requestAuthorization()
            }
        }
        .overlay {
            if alarmVM.isLoading {
                LoadingView()
            }
        }
    }

    private func header(isEnabled: Binding<Bool>) -> some View {
        HStack {
            Text("Alarm")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)

            Spacer()

            Toggle("", isOn: isEnabled)
                .tint(purple)
                .scaleEffect(1.1)
        }
        .padding(.top, 16)
    }

    private var bellIcon: some View {
        ZStack {
            Circle()
                .fill(purple.opacity(0.2))
                .frame(width: 70, height: 70)

            Image(systemName: alarmVM.alarmIsSet ? "bell.badge.fill" : "bell.fill")
                .font(.system(size: 30))
                .foregroundColor(purple)
        }
        .padding(.top, 8)
    }

    private var headerText: some View {
        Text("Choose a time range for waking up. You'll be woken when you're in the lightest sleep stage during that window, helping you feel more refreshed.")
            .font(.system(size: 14))
            .foregroundColor(Color.white.opacity(0.6))
            .multilineTextAlignment(.center)
            .padding(16)
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var alarmConfirmationCard: some View {
        VStack(spacing: 20) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(purple)
                Text("Alarm set for tonight")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(purple)
            }

            Divider()
                .background(Color.white.opacity(0.1))

            VStack(spacing: 12) {
                Text("Wake window")
                    .font(.system(size: 16))
                    .foregroundColor(Color.white.opacity(0.4))

                HStack(spacing: 12) {
                    Text("\(formattedTime(alarmVM.earliestTime)) \(amPM(alarmVM.earliestTime))")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)

                    Image(systemName: "arrow.right")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.4))

                    Text("\(formattedTime(alarmVM.latestTime)) \(amPM(alarmVM.latestTime))")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                }

                Text(windowMinutes.description + " minutes")
                    .font(.system(size: 16))
                    .foregroundColor(purple)
                    .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // TODO: Implement a delete alarm feature
    private var editAlarmButton: some View {
        Button(action: {
            alarmVM.alarmIsSet = false
        }) {
            Text("Edit Alarm")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(purple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(purple.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    private func timeWindowView(earliestBinding: Binding<Date>, latestBinding: Binding<Date>) -> some View {
        VStack(spacing: 12) {
            Text("Wake window")
                .font(.system(size: 14))
                .foregroundColor(Color.white.opacity(0.5))

            HStack(alignment: .center, spacing: 12) {
                Button(action: {
                    withAnimation(.none) {
                        if showLatestPicker { showLatestPicker = false }
                        showEarliestPicker.toggle()
                    }
                }) {
                    Text("\(formattedTime(alarmVM.earliestTime)) \(amPM(alarmVM.earliestTime))")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(showEarliestPicker ? purple : .white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .buttonStyle(PlainButtonStyle())

                Image(systemName: "arrow.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.4))

                Button(action: {
                    withAnimation(.none) {
                        if showEarliestPicker { showEarliestPicker = false }
                        showLatestPicker.toggle()
                    }
                }) {
                    Text("\(formattedTime(alarmVM.latestTime)) \(amPM(alarmVM.latestTime))")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(showLatestPicker ? purple : .white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .buttonStyle(PlainButtonStyle())
            }

            if !showEarliestPicker && !showLatestPicker {
                Text("Tap a time to edit")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.3))

                Text(windowMinutes.description + " minutes")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(purple)
                    .padding(.top, 5)
            }

            if showEarliestPicker {
                VStack(spacing: 4) {
                    Text("Earliest")
                        .font(.system(size: 12))
                        .foregroundColor(purple)
                    DatePicker("", selection: earliestBinding, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .tint(purple)
                        .colorScheme(.dark)
                        .compositingGroup()
                        .animation(.none, value: showEarliestPicker)
                }
            }

            if showLatestPicker {
                VStack(spacing: 4) {
                    Text("Latest")
                        .font(.system(size: 12))
                        .foregroundColor(purple)
                    DatePicker("", selection: latestBinding, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .tint(purple)
                        .colorScheme(.dark)
                        .compositingGroup()
                        .animation(.none, value: showLatestPicker)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // TODO: Wire repeat days to alarm scheduling logic
    private var repeatSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Repeat")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                Text(repeatLabel)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(16)

            Divider()
                .background(Color.white.opacity(0.05))

            VStack(spacing: 0) {
                dayToggle(label: "Monday", binding: $monday)
                dayToggle(label: "Tuesday", binding: $tuesday)
                dayToggle(label: "Wednesday", binding: $wednesday)
                dayToggle(label: "Thursday", binding: $thursday)
                dayToggle(label: "Friday", binding: $friday)
                dayToggle(label: "Saturday", binding: $saturday)
                dayToggle(label: "Sunday", binding: $sunday)
            }
        }
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func dayToggle(label: String, binding: Binding<Bool>) -> some View {
        VStack(spacing: 0) {
            Button(action: { binding.wrappedValue.toggle() }) {
                HStack {
                    Text(label)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    Spacer()
                    if binding.wrappedValue {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(purple)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

            if label != "Sunday" {
                Divider()
                    .background(Color.white.opacity(0.05))
                    .padding(.leading, 16)
            }
        }
    }

//    private var alarmStatus: some View {
//        VStack(spacing: 8) {
//            Text("Status: \(alarmVM.alarmAuthState.rawValue)")
//                .font(.system(size: 14))
//                .foregroundColor(.white)
//
//            Text("Scheduled alarms: \(sharedAlarmStore.runningAlarms.count)")
//                .font(.system(size: 13))
//                .foregroundColor(Color.white.opacity(0.5))
//        }
//        .frame(maxWidth: .infinity)
//        .padding(16)
//        .background(Color.white.opacity(0.07))
//        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
//    }

//    private var scheduledAlarms: some View {
//            VStack(alignment: .leading, spacing: 12) {
//                Text("Scheduled in Somni")
//                    .font(.headline)
//
//                if sharedAlarmStore.runningAlarms.isEmpty {
//                    Text("No alarms scheduled yet.")
//                        .foregroundStyle(.secondary)
//                } else {
//                    ForEach(sharedAlarmStore.runningAlarms) { alarm in
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text(alarm.title)
//                                .font(.body.weight(.semibold))
//                            if let fireDate = alarm.fireDate {
//                                Text(fireDate.formatted(date: .omitted, time: .shortened))
//                                    .foregroundStyle(.secondary)
//                            }
//                            Text(alarm.state)
//                                .font(.caption)
//                                .foregroundStyle(.secondary)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 16)
//                                .fill(Color(.systemGray6).opacity(0.5))
//                        )
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }

    private var scheduleAlarmButton: some View {
        Button(action: {
            dismissPickers()
            Task {
                await alarmVM.createAlarm(at: alarmVM.latestTime)
                alarmVM.alarmIsSet = true
            }
        }) {
            Text("Set Alarm")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(purple)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.top, 8)
    }

    private var alarmOffView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 70, height: 70)

                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color.white.opacity(0.3))
            }
            .padding(.top, 40)

            Text("Alarm is off")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.3))

            Text("Turn on the toggle above to set your wake window")
                .font(.system(size: 14))
                .foregroundColor(Color.white.opacity(0.2))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
    }
}

#Preview {
    AlarmView()
}
