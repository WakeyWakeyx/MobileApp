//
//  SignUp.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/12/26.
//

import Foundation


struct SignUpRequest: Codable {
    let name: String
    let email: String
    let password: String
    let confirmPassword: String
}

// TODO: Need to finish the sign up response and add the fields to it
struct SignUpResponse: Codable {
    let accessToken: String
}
