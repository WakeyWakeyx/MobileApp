//
//  ApiError.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/12/26.
//

import Foundation

// This will be the possible errors that we could get when making requests
enum NetworkErrors: Error {
    case invalidURL
    case invalidResponse
    case errorResponse(ErrorResponse)
    case decodingError(Error)
}

extension NetworkErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL (400): Unable to perform request for the given url.", comment: "invalidURL Error")
        case .invalidResponse:
            return NSLocalizedString("Invalid Response.", comment: "invalidResponse")
        case .errorResponse(let errorResponse):
            return NSLocalizedString("Error \(errorResponse.message ?? "")", comment: "Error Response")
        case .decodingError(let error):
            return NSLocalizedString("Unable to decode successfully.Error: \(error)", comment: "decodingError")
        }
    }
}

struct ErrorResponse: Codable {
    let message: String?
}
