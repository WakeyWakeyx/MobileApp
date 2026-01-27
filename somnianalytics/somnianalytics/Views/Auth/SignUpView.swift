//
//  SignUpView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/26/26.
//

import SwiftUI

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(AuthViewModel.self) private var vm
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    enum Field {
        case name, email, password, confirmPassword
    }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            header
            ScrollView{
                textFields
                createAccountButton
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
            focusedField = .name
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text(alertMessage)
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
        LabeledTextField(label: "Name", text: $name, placeholder: "")
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
            // TODO: Can throw an alert here if the password and confirm password don't match
            Task {
                do {
                    try await vm.signUp(
                        for: .init(
                            name: name,
                            email: email,
                            password: password,
                            confirmPassword: confirmPassword
                        )
                    )
                } catch {
                    // can throw an error here with alerts
                    await MainActor.run {
                        alertTitle = "Sign up failed"
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            }
        }) {
            Text("Sign Up")
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
    SignUpView()
}
