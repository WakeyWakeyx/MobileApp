//
//  RootTabView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/23/26.
//

import SwiftUI

struct RootTabView: View {
//    @Environment(Router.self) private var router: Router
    @State var router: Router = .init(level: 0, identifierTab: nil)
    var alarmService = AlarmService()
    var body: some View {
        TabView(selection: $router.selectedTab) {
            Tab("Home", systemImage: "house", value: TabDestination.home) {
                NavigationContainer(parentRouter: router, tab: .home) {
                    HomeView()
                }
            }
            
            Tab("Details", systemImage: "chart.bar", value: TabDestination.details) {
                NavigationContainer(parentRouter: router, tab: .details){
                    DetailsView()
                }
            }
            
            Tab("History", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90", value: TabDestination.history){
                NavigationContainer(parentRouter: router, tab: .history) {
                    HistoryView()
                }
            }
            
            Tab("Alarm", systemImage: "alarm", value: TabDestination.alarm){
                NavigationContainer(parentRouter: router, tab: .alarm) {
                    AlarmView()
                        .environment(alarmService)
                }
            }
        }
    }
}

#Preview {
    RootTabView()
}
