//
//  KeyChainManager.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/13/26.
//

import Foundation


enum KeyChainKeys: String, CaseIterable {
    case jwttoken = "JWTToken"
}

enum KeyChainError: LocalizedError {
    case duplicateEntry
    
    case unknownError(OSStatus) //need to figure out what OSStatus is
}

//This is the protocol for the keychain manager that allows for generic types and also has keys that will let us know what type of value it is
protocol KeyChainProtocol {
    func save<T: Codable>(_ value: T, for key: KeyChainKeys) throws
    func load<T: Codable>(_ type: T.Type, for key: KeyChainKeys) throws -> T?
    func delete(for key: KeyChainKeys) throws
}

// TODO: build out the functionality of this, needs a set token, get token, and delete token method
final class KeyChainManager: KeyChainProtocol {
    func save<T>(_ value: T, for key: KeyChainKeys) throws {
        // service, account, password, class
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: ,
            kSecAttrAccount as String: "",
            kSecValueData as String: "",
            kSecClass as String: ""
        ]
    }
    
    func load<T>(_ type: T.Type, for key: KeyChainKeys) throws -> T? {
        // service, account, class, return-data, matchlimit
    }
    
    func delete(for key: KeyChainKeys) throws {
        <#code#>
    }
    
    
}
