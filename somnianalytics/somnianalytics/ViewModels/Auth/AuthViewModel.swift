//
//  SignUpViewModel.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/26/26.
//

import Foundation
import Observation

@Observable
class AuthViewModel {
    private let authService = AuthService()
    var isLoading: Bool = false
    // Adding these for when we are going to be signing up and after we have sucessfully signed up
    var authState: AuthState = .unauthenticated
    var isAuthenticated: Bool {
        authState == .authenticated
    }
    
    func signUp(for signUpRequest: SignUpRequest) async throws {
        do {
            authState = .authenticating
            isLoading = true
            try await authService.signUpUser(for: signUpRequest)
            authState = .authenticated
            isLoading = true
        } catch {
            authState = .unauthenticated
            isLoading = false
            throw error
        }
    }
    
    func login(for loginRequest: LoginRequest) async throws {
        do {
            authState = .authenticating
            isLoading = true
            try await authService.loginUser(for: loginRequest)
            authState = .authenticated
            isLoading = false
        } catch {
            authState = .unauthenticated
            isLoading = false
            throw error
        }
    }
}

