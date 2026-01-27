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
                else if authVM.authState == .unauthenticated {
                    // TODO: WILL CHANGE THIS TO AN AUTH ENTRY VIEW
                    SignUpView()
                }
                else if authVM.authState == .authenticating{
                    LoadingView()
                }
            }
            .environment(authVM)
            
        }
    }
}
