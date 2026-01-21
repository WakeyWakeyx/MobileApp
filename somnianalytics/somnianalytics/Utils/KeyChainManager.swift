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

enum KeyChainServices: String {
    case somniAnalyticsApi = "somniAnalyticsApi" // will change this later when we get the api stuff figured out and get the right endpoint name
    case unknownService = "unknownServie"
}

enum KeyChainError: LocalizedError {
    case duplicateEntry
    case noEntryFound
    case deleteFailed
    case unexpectedDataRetrieved
    case saveFailed(status: OSStatus)
    case getFailed(status: OSStatus)
    case unknownError(status: OSStatus) //need to figure out what OSStatus is
}

// TODO: build out the functionality of this, needs a set token, get token, and delete token method
final class KeyChainManager {
    private let service = "com.somni.somnianalytics"
    func save<T: Codable>(_ value: T, for key: KeyChainKeys, account: String) throws {
        let data = try JSONEncoder().encode(value)
        
        //building query here
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: value
        ]
        
        // deleting item first before adding so we don't get a duplicate error, and so we save the most recent data
        let deleteStatus = SecItemDelete(query as CFDictionary)
        
        guard deleteStatus != errSecSuccess else {
            throw KeyChainError.deleteFailed
        }
        
        // adding the item here
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // checking the result of adding this
        
        guard status != errSecDuplicateItem else {
            throw KeyChainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeyChainError.saveFailed(status: status)
        }
        
        print("saved successfully to keychain")
    }
    
    func get<T: Codable>(for key: KeyChainKeys, account: String) throws -> T? {
        // making the query for looking up the key here
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue
        ]
        
        
        // doing the lookup here
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        
        // checking for errors here
        guard status != errSecItemNotFound else { throw KeyChainError.noEntryFound }
        guard status == errSecSuccess else { throw KeyChainError.getFailed(status: status) }
        
        // extracting data here
        guard let existingItem = result as? [String: Any],
              let data = existingItem[kSecValueData as String] as? Data,
              let decodedObject = String(data: data, encoding: String.Encoding.utf8),
              let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeyChainError.unexpectedDataRetrieved
        }
        
        // TODO: Need to make the return type for this function and decide whether or not to take anything in with the generics or not
    
        
    }
    
    func delete(for key: KeyChainKeys) throws {
        <#code#>
    }
    
    
}
