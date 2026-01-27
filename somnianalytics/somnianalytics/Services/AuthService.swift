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
    private let tokenProvider: TokenProvider
    private let networkHelpers: NetworkHelpers
    
    init(apiClient: ApiClientProtocol = ApiClient(), tokenProvider: TokenProvider = TokenProvider(), networkHelpers: NetworkHelpers = NetworkHelpers()) {
        self.apiClient = apiClient
        self.tokenProvider = tokenProvider
        self.networkHelpers = networkHelpers
    }
    
    func loginUser(for loginRequest: LoginRequest) async throws {
        let confirmedURL = try networkHelpers.confirmURL(url: "https://wilbur-unentertained-brianna.ngrok-free.dev/api/auth/login")
        let resource = Resource<LoginResponse>(url: confirmedURL, method: .post(loginRequest))
        let response: LoginResponse = try await apiClient.load(resource) //this is making the request here
        try tokenProvider.setToken(response.jwtToken)
    }
    
     
    func signUpUser(for signUpRequest: SignUpRequest) async throws {
        // this url will change everytime the ngrok url changes
        let confirmedURL = try networkHelpers.confirmURL(url: "https://wilbur-unentertained-brianna.ngrok-free.dev/api/auth/create")
        let resource = Resource<SignUpResponse>(url: confirmedURL, method: .post(signUpRequest))
        let response: SignUpResponse = try await apiClient.load(resource)
        
        try tokenProvider.setToken(response.jwtToken)
        
        let token = try tokenProvider.getToken()
        print("token: \(token ?? "NO TOKEN FOUND")")
    }
}
