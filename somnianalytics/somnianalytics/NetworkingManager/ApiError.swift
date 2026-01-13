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


struct ErrorResponse: Codable {
    let message: String?
}
