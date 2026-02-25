//
//  NavigationButton.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/15/26.
//

import SwiftUI

struct NavigationButton<Content: View>: View {
    let destination: Destination
    @ViewBuilder var content: () -> Content
    @Environment(Router.self) private var router
    
    // Have the different initalizers so that we can use the navigation button easily with the different types of destinations
    init(
        destination: Destination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = destination
        self.content = content
    }
    
    init(
        push destination: PushDestination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = .push(destination)
        self.content = content
    }
    
    init(
        sheet destination: SheetDestination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = .sheet(destination)
        self.content = content
    }
    
    // Here is where the navigation action happens
    var body: some View {
        Button(action: { router.navigate(to: destination) }) {
            content()
        }
    }
}
