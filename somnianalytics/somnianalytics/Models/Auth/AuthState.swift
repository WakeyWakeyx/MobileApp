//
//  AuthState.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/27/26.
//

import Foundation

// Enum for the different states that will be determining the state of the authorization process
enum AuthState {
    case unauthenticated
    case authenticating
    case authenticated
    case onboarding
}
