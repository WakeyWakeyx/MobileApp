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
    @State private var predictionManager = MLModel_Manager()
    @State private var modelContext: ModelContext
    @State private var deviceManager: SomnitrixManager
    
    init() {
        do {
            let container = try ModelContainer(
                for: Metrics.self,
            )
            let context = ModelContext(container)
            self.modelContext = context
            self.deviceManager = SomnitrixManager(context: context)
        } catch {
            //TODO: recovery
            fatalError("Unable to create model context")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if true {
                    RootTabView()
                }
                else {
                    NavigationContainer(parentRouter: router) {
                        AuthEntryView()
                    }
                }
            }
            .onAppear {
                deviceManager.setPredictionManager(predictionManager)
            }
        }
        .environment(authVM)
        .environment(router)
        .environment(deviceManager)
        .environment(predictionManager)
        .modelContext(modelContext)
    }
}
