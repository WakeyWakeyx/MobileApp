//
//  AuthService.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/12/26.
//

import Foundation


struct AuthService {
    let basePath = "/api" // not sure if this is right but might modify later
    private let apiClient: ApiClientProtocol
    private let keychainManager = KeyChainManager()
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    func loginUser(for loginRequest: LoginRequest) async throws {
        guard let confirmedURl = URL(string: "https://fakestoreapi.com/products") else {
            throw NetworkErrors.invalidURL
        }
        
        let resource = Resource<LoginResponse>(url: confirmedURl, method: .post(loginRequest))
        let response: LoginResponse = try await apiClient.load(resource) //this is making the request here
        
        try keychainManager.save(response.accessToken, for: KeyChainKeys.jwttoken, account: response.nameOfUser)
    }
}
