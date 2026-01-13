//
//  TokenProvider.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/13/26.
//

import Foundation


protocol TokenProviderProtocol {
    func getToken() -> String?
    func clearToken() -> Void
    func setToken(_ token: String) -> Void
}

// TODO: Need to finish making this 
struct TokenProvider: TokenProviderProtocol {
    func getToken() -> String? {
        <#code#>
    }
    
    func clearToken() {
        <#code#>
    }
    
    func setToken(_ token: String) {
        <#code#>
    }
}
