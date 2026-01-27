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
    var isSignedUp: Bool = false
    
    func signUp(for signUpRequest: SignUpRequest) async throws {
        do {
            let response = try await authService.signUpUser(for: signUpRequest)
        } catch {
            throw error
        }
    }
    
    func login(for loginRequest: LoginRequest) async throws {
        do {
            try await authService.loginUser(for: loginRequest)
        } catch {
            throw error 
        }
    }
}

