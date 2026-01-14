//
//  HttpMethod.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/12/26.
//

import Foundation

//This just represents the http methods that are supported by the networking manager, 
enum HttpMethods {
    case get([URLQueryItem])
    case post(any Codable)
    case put(any Codable)
    case delete
    
    var name: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            case .delete:
                return "DELETE"
        }
    }
}


