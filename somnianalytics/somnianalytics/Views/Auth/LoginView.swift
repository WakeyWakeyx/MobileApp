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
    @State private var showPassword = false

    
    enum Field {
        case email, password
    }
    @FocusState private var focusedField: Field?
    
    
    var body: some View {
        ZStack {
            // Black base
            Color.black.ignoresSafeArea()

            // Purple glow at top behind icon
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.4),
                    Color.clear
                ]),
                center: .top,
                startRadius: 10,
                endRadius: 500
            )
            .ignoresSafeArea()
            
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
    }
    
    
    private var header: some View {
        VStack(spacing: 12) {
            // App icon
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(red: 0.55, green: 0.35, blue: 0.95))
                    .frame(width: 70, height: 70)
                
                // Moon Logo
                Image(systemName: "moon.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.black)
            }
            .padding(.top, 20)
            
            // Title
            Text("Welcome Back!")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
            
            // Subtitle
            Text("will add something")
                .font(.system(size: 15))
                .foregroundColor(Color.white.opacity(0.55))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 32)
    }
    
    @ViewBuilder
    private var textFields: some View {
        // Email
        LabeledTextField(label: "Email", text: $email, placeholder: "john@example.com", inputType: .emailAddress, icon: "envelope")
            .padding(.horizontal, 24)
            .onSubmit {
                focusedField = .password
            }
        
        // Password - built manually to support Forgot? link
        VStack(alignment: .leading, spacing: 8) {
            // Label row with Forgot? link on the right
            HStack {
                Text("Password")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.7))
                Spacer()
                Button(action: {
                    // TODO: Handle forgot password
                }) {
                    Text("Forgot?")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.55, green: 0.35, blue: 0.95))
                }
            }

            // Input box with show/hide toggle
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(Color.white.opacity(0.4))

                // Switch between visible and hidden password
                if showPassword {
                    TextField("", text: $password, prompt:
                        Text("******").foregroundColor(Color.white.opacity(0.5))
                    )
                    .foregroundColor(.white)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        focusedField = .none
                    }
                } else {
                    SecureField("", text: $password, prompt:
                        Text("******").foregroundColor(Color.white.opacity(0.5))
                    )
                    .foregroundColor(.white)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        focusedField = .none
                    }
                }

                Spacer()

                // Eye icon to change password visibility
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye" : "eye.slash")
                        .foregroundColor(Color.white.opacity(0.4))
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(.horizontal, 24)
    }
    
    private var loginButton: some View {
        VStack(spacing: 16) {
            // Login In
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
                Text("Log In")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color(red: 0.55, green: 0.35, blue: 0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            
            // Footer
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .foregroundColor(Color.white.opacity(0.5))
                Button(action: {
                    // TODO: MAKE THIS GO TO SIGN UP PAGE
                }) {
                    Text("Sign up")
                        .foregroundColor(Color(red: 0.55, green: 0.35, blue: 0.95))
                }
            }
            .font(.system(size: 14))
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 32)
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel())
}
