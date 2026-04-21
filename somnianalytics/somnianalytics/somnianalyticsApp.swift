//
//  somnianalyticsApp.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/5/26.
//

import SwiftData
import SwiftUI

@main
struct somnianalyticsApp: App {
    @State private var authVM = AuthViewModel()
    @State private var router = Router(level: 0, identifierTab: nil)
    @State private var modelContext: ModelContext
    @State private var deviceManager: SomniManager
    
    init() {
        do {
            let container = try ModelContainer(
                for: SensorMetrics.self, AccelerometerMetrics.self,
            )
            let context = ModelContext(container)
            self.modelContext = context
            self.deviceManager = SomniManager(context: context)
        } catch {
            //TODO: recovery
            fatalError("Unable to create model context")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if true {
                RootTabView()
            }
//            if authVM.isAuthenticated {
//                RootTabView()
//            }
            else {
                NavigationContainer(parentRouter: router) {
                    AuthEntryView()
                }
            }
        }
        .environment(authVM)
        .environment(router)
        .environment(deviceManager)
        .modelContext(modelContext)
    }
}
