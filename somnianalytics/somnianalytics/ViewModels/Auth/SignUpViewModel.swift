//
//  SignUpViewModel.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/26/26.
//

import Foundation
import Observation

@Observable
class SignUpViewModel {
    private let authService = AuthService()
    // TODO: NEED TO FINISH THIS
    func signUp(for signUpRequest: SignUpRequest) {
        do {
            let response = try await authService.signUpUser(for: signUpRequest)
            
        }
    }
}

