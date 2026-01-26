//
//  NetworkHelpers.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/26/26.
//

import Foundation


struct NetworkHelpers {
    func confirmURL (url: String) throws -> URL {
        guard let confirmedURL = URL(string: url) else {
            throw NetworkErrors.invalidURL
        }
        return confirmedURL
    }
}
