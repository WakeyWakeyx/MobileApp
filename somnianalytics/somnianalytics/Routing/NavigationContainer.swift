//
//  NavigationContainer.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/15/26.
//

import SwiftUI


struct NavigationContainer<Content: View>: View {
    @State var router: Router
    @ViewBuilder var content: () -> Content
    
    init(
        router: Router,
        tab: TabDestination? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.router = router
        self.content = content
    }
    
    var body: some View {
        InnerContainer(router: router) {
            content()
        }
        .environment(router)
        .onOpenURL(perform: openDeepLinkIfFound(for:))
    }
    
    // TODO: Need to finish this
    func openDeepLinkIfFound(for url: URL) {
        
    }
}

private struct InnerContainer<Content: View>: View {
    @Bindable var router: Router
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        NavigationStack(path: $router.navigationStackPath) {
            content()
                .navigationDestination(for: PushDestination.self) { destination in
                    view(for: destination)
                }
        }
//        .sheet(item: $router.presentingSheet) { sheet in
//            navigationView(for: sheet, from: router)
//        } CAN ADD THIS IN LATER IF WE NEED IT
    }
    
    
    // CAN ADD THIS LATER AS WELL IF WE NEED IT 
//    @ViewBuilder func navigationView(for destination: SheetDestination, from router: Router) -> some View {
//        NavigationContainer(parentRouter: router) {
//            view(for: destination)
//        }
//    }
}
