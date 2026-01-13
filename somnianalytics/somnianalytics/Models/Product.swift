//
//  Product.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/12/26.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
}
