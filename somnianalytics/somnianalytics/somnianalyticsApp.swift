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
    @State private var router = Router(level: 0, identifierTab: .home)
    
    var body: some Scene {
        WindowGroup {
            NavigationContainer(parentRouter: router) {
                if authVM.isAuthenticated {
                    HomeView()
                }
                else {
                    AuthEntryView()
                }
            }
            .environment(authVM)
            .environment(router)
        }
    }
}
