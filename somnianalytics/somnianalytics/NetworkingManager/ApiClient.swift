//
//  ApiClient.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/12/26.
//

import Foundation

struct Resource<T: Codable> {
    //url that we are sending the request to
    let url: URL?
    
    //defaults to get request
    var method: HttpMethods = .get([])
    
    //headers of the request
    var headers: [String: String]? = nil
    
    //the type of the data that we are working with
    var modelType: T.Type
}

struct ApiClient {
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        self.session = URLSession(configuration: configuration) //making sure that we are always using the json header as the content type
    }
    
    
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        guard let confirmedURL = resource.url else {
            throw NetworkErrors.invalidURL
        }
        var request = URLRequest(url: confirmedURL)
        
        //can add headers over here to the request if we have any
        if let headers = resource.headers{
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // set the http body if needed
        switch resource.method {
            case .get(let queryItems):
                var components = URLComponents(url: confirmedURL, resolvingAgainstBaseURL: false)
                components?.queryItems = queryItems
            
                guard let url = components?.url else {
                    throw NetworkErrors.invalidURL
                }
            
                request.url = url
            case .post(let data), .put(let data):
                request.httpMethod = resource.method.name
                request.httpBody = data
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
            default:
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkErrors.errorResponse(errorResponse)
        }
        
        //Decoding the json now
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(resource.modelType, from: data)
            return result
        } catch {
            throw NetworkErrors.decodingError(error)
        }
        
    }
}
