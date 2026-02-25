//
//  PushDestination.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/15/26.
//


/**
 This file will be used identity the different pages that we have
*/
import Foundation
import SwiftUI

//Hashable so that we can pass it to functions and custom string convertible so that we can print out the route when logging/debugging
enum PushDestination: Hashable, CustomStringConvertible {
    case signUp
    case login
    /*case forgot*/ // TODO: for forgot password we need to add that functionality
    
    var description: String {
        switch self {
        case .signUp: 
            ".signUp"
        case .login:
            ".login"
//        case .forgot:
//            ".forgot"
        }
    }
}


@ViewBuilder
func pushDestinationView(for destination: PushDestination) -> some View {
    switch destination {
        case .login:
            LoginView()
        case .signUp:
            SignUpView()
    }
}


