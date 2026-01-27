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
    
    // Adding these for when we are going to be signing up and after we have sucessfully signed up 
    var isSignedUp: Bool = false
    var isSigningUp: Bool = false
    // TODO: NEED TO FINISH THIS
    func signUp(for signUpRequest: SignUpRequest) async throws {
        do {
            try await authService.signUpUser(for: signUpRequest)
        } catch {
            throw error
        }
    }
}

