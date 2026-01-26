//
//  TokenProvider.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/13/26.
//

import Foundation

//This file is built to handle the JWT token management for the app
protocol TokenProviderProtocol {
    func getToken() throws -> String?
    func clearToken() throws
    func setToken(_ token: String) throws
}

struct TokenProvider: TokenProviderProtocol {
    private let keychainManager: KeyChainManager
    
    init(keychainManager: KeyChainManager) {
        self.keychainManager = keychainManager
    }
    
    func getToken() throws ->  String? {
        try keychainManager.get(for: KeyChainKeys.jwttoken)
    }
    
    func clearToken() throws {
        try keychainManager.delete(for: KeyChainKeys.jwttoken)
    }
    
    func setToken(_ token: String) throws {
        try keychainManager.save(token, for: KeyChainKeys.jwttoken)
    }
}
