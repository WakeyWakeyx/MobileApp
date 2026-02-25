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
    @State private var router = Router(level: 0, identifierTab: nil)
    
    var body: some Scene {
        WindowGroup {
            if authVM.isAuthenticated {
                RootTabView()
            }
            else {
                NavigationContainer(parentRouter: router) {
                    AuthEntryView()
                }
            }
        }
        .environment(authVM)
        .environment(router)
    }
}
