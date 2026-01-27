//
//  ContentView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/5/26.
//

import SwiftUI

struct ContentView: View {
    let httpClient = ApiClient()
    
    var body: some View {
        SignUpView()
    }
}

#Preview {
    SignUpView()
}
