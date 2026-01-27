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

struct SignUpResponse: Codable {
    let jwtToken: String
    let name: String
    let email: String
}
