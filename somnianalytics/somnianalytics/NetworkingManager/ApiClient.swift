//
//  ApiClient.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/12/26.
//

import Foundation

protocol ApiClientProtocol {
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T
}


struct Resource<T: Codable> {
    //url that we are sending the request to
    let url: URL
    
    //defaults to get request
    var method: HttpMethods = .get([])
    
    //headers of the request
    var headers: [String: String]? = nil
    
    // this will if we need to inject the jwt token or not
    var needsToken: Bool = false
}

struct ApiClient: ApiClientProtocol {
    private let session: URLSession
    private let keychainManager: KeyChainManager
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        self.session = URLSession(configuration: configuration) //making sure that we are always using the json header as the content type
        self.keychainManager = KeyChainManager()
    }
    
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        var request = URLRequest(url: resource.url)
        
        //adding additional headers to the request if we have any, and also making sure to not overwrite the previous headers that we added by default
        if let headers = resource.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Injecting token header here if we need the header
        if resource.needsToken {
            do {
                let token:String = try keychainManager.get(for: KeyChainKeys.jwttoken)
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } catch let error as KeyChainError {
                throw NetworkErrors.authError(error)
            }
        }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        // set the http body if needed
        switch resource.method {
            case .get(let queryItems):
                var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
                components?.queryItems = queryItems
            
                guard let url = components?.url else {
                    throw NetworkErrors.invalidURL
                }
            
                request.url = url
                request.httpMethod = resource.method.name
            case .post(let data), .put(let data):
                request.httpMethod = resource.method.name
                request.httpBody = try encoder.encode(data)
            case .delete:
                request.httpMethod = resource.method.name
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkErrors.invalidResponse
        }
        
        //can also check for specific http errors
        switch httpResponse.statusCode {
            case 200...299:
                break //that's because this is a success so we are just breaking from the switch
            case 401, 403:
                throw NetworkErrors.authError(NetworkErrors.invalidResponse)
            default:
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkErrors.errorResponse(errorResponse)
        }
        
        //Decoding the json now
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            throw NetworkErrors.decodingError(error)
        }
        
    }
}

