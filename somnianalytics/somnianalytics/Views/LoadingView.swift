//
//  LoadingView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/27/26.
//

import SwiftUI

// Will refine this later but just need a placeholder for now
struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Loading...")
        }
    }
}

#Preview {
    LoadingView()
}
