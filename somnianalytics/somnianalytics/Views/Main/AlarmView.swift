//
//  AlarmView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/23/26.
//

import SwiftUI

struct AlarmView: View {
    var body: some View {
        VStack {
            Text("Alarm View")
                .font(.largeTitle)
        }
        .navigationTitle("Alarm")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AlarmView()
}
