//
//  SignUpView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/26/26.
//

import SwiftUI

struct SignUpView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    enum Field {
        case username, email, password, confirmPassword
    }
    var body: some View {
        header
        ScrollView{
            textFields
        }
        
    }
    
    private var header: some View {
        Text("Create Account")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
    
    @ViewBuilder
    private var textFields: some View {
        LabeledTextField(label: "Username", text: $username, placeholder: "")
            .padding()
        
        LabeledTextField(label: "Email", text: $email, placeholder: "JohnDoe@test.com", inputType: .emailAddress)
            .padding()
        
        LabeledTextField(label: "Password", text: $password, placeholder: "******", isSecure: true)
            .padding()
        
        LabeledTextField(label: "Confirm Password", text: $confirmPassword, placeholder: "******", isSecure: true)
            .padding()
    }
    
    private var createAccountButton: some View {
        Button(action: {
            
        })
    }
}

#Preview {
    SignUpView()
}
