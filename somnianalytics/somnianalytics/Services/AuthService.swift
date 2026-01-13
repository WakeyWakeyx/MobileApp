//
//  AuthService.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/12/26.
//

import Foundation


struct AuthService {
    let basePath = "/api" // not sure if this is right but might modify later
    
    func loginUser(for loginRequest: LoginRequest) -> Void {
        let resource = Resource(url: URL(string: "https://fakestoreapi.com/products")!, modelType: LoginRequest)
        
    }
}
