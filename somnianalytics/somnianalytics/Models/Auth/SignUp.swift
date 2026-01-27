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
}

struct SignUpResponse: Codable {
    let name: String
    let email: String
    let jwtToken: String
}
