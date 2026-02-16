//
//  Router.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/15/26.
//

import Foundation
import SwiftUI

@Observable
final class Router {
    let id = UUID()
    let level: Int
    
    // Specifies the tab that the router was built for
    let identifierTab: TabDestination?
    
    var selectedTab : TabDestination?
    
    // The values in the navigation path
    var navigationStackPath: [PushDestination] = []
    
    // Current presented sheet
    var presentingSheet: SheetDestination?
    
    // This references the parent router to form a heierarchy
    // The router level increases for the children
    weak var parent: Router?
    
    
    init(level: Int, identifierTab: TabDestination?) {
        self.level = level
        self.identifierTab = identifierTab
        self.parent = nil
    }
    
    private func resetContent() {
        navigationStackPath = []
        presentingSheet = nil
    }
}

// MARK: Navigation

extension Router {
    func navigate(to destination: Destination) {
        switch destination {
        case let .tab(tab):
            select(tab: tab)
        case let .push(destination):
            push(destination)
        case let .sheet(destination):
            present(sheet: destination)
        }
    }
    
    func select(tab destination: TabDestination) {
        if level == 0 {
            selectedTab = destination
        } else {
            parent?.select(tab: destination)
            resetContent()
        }
    }
    
    func push(_ destination: PushDestination) {
        navigationStackPath.append(destination)
    }
    
    func present(sheet destination: SheetDestination) {
        presentingSheet = destination
    }
}







