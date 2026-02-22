//
//  Destination.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/15/26.
//

import Foundation


enum Destination: Hashable {
    case tab(_ destination: TabDestination)
    case push(_ destination: PushDestination)
    case sheet(_ destination: SheetDestination)
}


