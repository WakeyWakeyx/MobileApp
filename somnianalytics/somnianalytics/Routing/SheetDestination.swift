//
//  SheetDestination.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/15/26.
//

import Foundation

// Might use this in the future, but we aren't currently using it. 
enum SheetDestination: Hashable, CustomStringConvertible {
    case sleepDetails(id: Int)
    
    var description: String {
        switch self {
        case .sleepDetails(id: let id):
            ".sleepDetails(\(id))"
        }
    }
}

extension SheetDestination: Identifiable {
    var id: String {
        switch self {
        case let .sleepDetails(id):
            String(id)
        }
    }
}
