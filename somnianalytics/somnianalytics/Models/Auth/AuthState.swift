//
//  AuthState.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/27/26.
//

import Foundation

// Enum for the different states that will be determining the state of the authorization process
enum AuthState {
    case unauthenticated // show login/signup pages
    case authenticating // show loading indicator
    case authenticated // show the main part of the app
    case onboarding // will show the user the onboarding stages of the application 
}
