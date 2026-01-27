//
//  SignUpViewModel.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/26/26.
//

import Foundation
import Observation

// Enum for the different states that will be determining the state of the authorization process
enum AuthState {
    case unauthenticated
    case authenticating
    case authenticated
    case onboarding
}

@Observable
class AuthViewModel {
    private let authService = AuthService()
    // TODO: Need to add the way to show loading state in the project when an api call is being made
    var isLoading: Bool = false
    // Adding these for when we are going to be signing up and after we have sucessfully signed up
    var authState: AuthState = .unauthenticated
    var isAuthenticated: Bool {
        authState == .authenticated
    }
    
    func signUp(for signUpRequest: SignUpRequest) async throws {
        do {
            authState = .authenticating
            try await authService.signUpUser(for: signUpRequest)
            authState = .authenticated
        } catch {
            throw error
        }
    }
    
    func login(for loginRequest: LoginRequest) async throws {
        do {
            authState = .authenticating
            try await authService.loginUser(for: loginRequest)
            authState = .authenticated
        } catch {
            throw error 
        }
    }
}

