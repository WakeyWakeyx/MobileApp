//
//  AuthError.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/13/26.
//

import Foundation


enum AuthError: LocalizedError {
    case invalidCredentials
    case tokenExpired
    case tokenNotReceived
    case unknownError
    
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("Invalid Credentials", comment: "Please enter valid credentials please.")
        case .tokenNotReceived:
            return NSLocalizedString("Token not received", comment: "Token wasn't received from api")
        case .tokenExpired:
            return NSLocalizedString("Token Expired", comment: "Auth token has expired")
        case .unknownError:
            return NSLocalizedString("Unknown Error", comment: "An unknown error has occured please contact support")
        }
    }
}
