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
        SignUpView()
    }
}

#Preview {
    ContentView()
}
