//
//  somnianalyticsApp.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/5/26.
//

import SwiftUI

@main
struct somnianalyticsApp: App {
    @State private var signUpVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            SignUpView()
            .environment(signUpVM)
        }
    }
}
