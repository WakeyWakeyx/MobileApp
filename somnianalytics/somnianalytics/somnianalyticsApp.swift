//
//  somnianalyticsApp.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/5/26.
//

import SwiftUI

@main
struct somnianalyticsApp: App {
    @State private var authVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.isAuthenticated {
                    HomeView()
                }
                else {
                    // TODO: WILL CHANGE THIS TO AN AUTH ENTRY VIEW
                    SignUpView()
                }
            }
            .environment(authVM)
            
        }
    }
}
