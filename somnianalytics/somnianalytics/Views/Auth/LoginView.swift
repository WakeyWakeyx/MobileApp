//
//  LoginView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/27/26.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @Environment(AuthViewModel.self) private var vm
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    enum Field {
        case email, password
    }
    @FocusState private var focusedField: Field?
    
    
    var body: some View {
        VStack{
            header
            ScrollView {
                textFields
                loginButton
            }
        }
        .toolbar {
            if focusedField != nil {
                ToolbarItem {
                    Button(action: {
                        focusedField = nil
                    }) {
                        Text("Done")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .onAppear {
            focusedField = .email
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    
    private var header: some View {
        VStack {
            Text("Hello")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            Text("Welcome Back!")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var textFields: some View {
        LabeledTextField(label: "Email", text: $email)
            .padding()
            .onSubmit {
                focusedField = .password
            }
        
        LabeledTextField(label: "Password", text: $password, isSecure: true)
            .padding()
            .onSubmit {
                focusedField = .none
            }
    }
    
    private var loginButton: some View {
        Button(action: {
            // TODO: NEED TO ADD INPUT VALIDATION HERE
            Task {
                do {
                    try await vm.login(
                        for: .init(
                            email: email,
                            password: password
                        )
                    )
                } catch {
                    // can throw an error here with alerts
                    await MainActor.run {
                        alertTitle = "Login failed"
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            }
        }) {
            Text("Login")
                .frame(width: 252)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.blue.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel())
}
