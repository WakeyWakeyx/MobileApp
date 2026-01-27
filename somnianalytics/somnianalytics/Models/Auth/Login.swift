//
//  Login.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/12/26.
//

import Foundation


struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let jwtToken: String // This is the jwt that will be returned to the user
}
