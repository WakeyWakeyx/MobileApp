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
    private let tokenProvider: TokenProvider
    private let networkHelpers: NetworkHelpers
    init(apiClient: ApiClientProtocol, tokenProvider: TokenProvider, networkHelpers: NetworkHelpers) {
        self.apiClient = apiClient
        self.tokenProvider = TokenProvider(keychainManager: keychainManager)
        self.networkHelpers = networkHelpers
    }
    func loginUser(for loginRequest: LoginRequest) async throws {
        guard let confirmedURl = URL(string: "https://fakestoreapi.com/products") else {
            throw NetworkErrors.invalidURL
        }
        
        let resource = Resource<LoginResponse>(url: confirmedURl, method: .post(loginRequest))
        let response: LoginResponse = try await apiClient.load(resource) //this is making the request here
        try tokenProvider.setToken(response.accessToken)
    }
    
    // TODO: NEED TO FINISH THIS AND GET THE RIGHT URLS IN THERE 
    func signUpUser(for signUpRequest: SignUpRequest) async throws {
        let confirmedURL = try networkHelpers.confirmURL(url: "https://fakestoreapi.com/products")
        
    }
}
