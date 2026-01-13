//
//  ContentView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/5/26.
//

import SwiftUI

struct ContentView: View {
    let httpClient = ApiClient()
    @State private var products: [Product] = []
    // Has an example of us using the http client in here
    var body: some View {
        List(products) { product in
            Text(product.title)
        }.task {
            do {
                let resource = Resource(url: URL(string: "https://fakestoreapi.com/products"), modelType: [Product].self)
                products = try await httpClient.load(resource)
            } catch {
                print(error)
            }
            
            
        }
    }
}

#Preview {
    ContentView()
}
