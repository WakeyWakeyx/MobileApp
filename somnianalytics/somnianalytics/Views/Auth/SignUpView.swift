//
//  SignUpView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/26/26.
//

import SwiftUI

struct SignUpView: View {
    @Environment(AuthViewModel.self) private var vm
    @Environment(Router.self) private var router
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    enum Field {
        case name, email, password, confirmPassword
    }
    @FocusState private var focusedField: Field?
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        ZStack {
            // Black base
            Color.black.ignoresSafeArea()
            
            // Purple glow
            RadialGradient (
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.4),
                    Color.clear
                ]),
                center: .top,
                startRadius: 10,
                endRadius: 700
            )
            .ignoresSafeArea()
            
            VStack {
                header
                ScrollView{
                    textFields
                    createAccountButton.padding(.top, 20)
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
        }
        // Auto focus name field when screen loads
        .onAppear {
            focusedField = .name
        }
        // Show loading spinner while request is in flight
        .overlay {
            if vm.isLoading {
                LoadingView()
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            // App icon
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(red: 0.55, green: 0.35, blue: 0.95))
                    .frame(width: 70, height: 70)

                Image(systemName: "moon.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.black)
            }
            .padding(.top, 20)
            
            // Title
            Text("SleepSmart")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)

            // Subtitle
            Text("will add something later")
                .font(.system(size: 15))
                .foregroundColor(Color.white.opacity(0.55))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 24)
    }
    
    @ViewBuilder
    private var textFields: some View {
        LabeledTextField(label: "Full Name", text: $name, placeholder: "John Doe", icon: "person")
            .padding(.horizontal, 24)
            .onSubmit {
                focusedField = .email
            }
        
        LabeledTextField(label: "Email", text: $email, placeholder: "JohnDoe@test.com", inputType: .emailAddress, icon: "envelope")
            .padding(.horizontal, 24)
            .onSubmit {
                focusedField = .password
            }
        
        // Password
        VStack(alignment: .leading, spacing: 8) {
            Text("Password")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.white.opacity(0.7))

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
                    .onSubmit { focusedField = .confirmPassword }
                } else {
                    SecureField("", text: $password, prompt:
                        Text("******").foregroundColor(Color.white.opacity(0.5))
                    )
                    .foregroundColor(.white)
                    .focused($focusedField, equals: .password)
                    .onSubmit { focusedField = .confirmPassword }
                }

                Spacer()

                // Eye icon toggles password visibility
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(Color.white.opacity(0.4))
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(.horizontal, 24)

        // Confirm Password
        VStack(alignment: .leading, spacing: 8) {
            Text("Confirm Password")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.white.opacity(0.7))

            HStack {
                Image(systemName: "lock")
                    .foregroundColor(Color.white.opacity(0.4))

                // Switch between visible and hidden confirm password
                if showConfirmPassword {
                    TextField("", text: $confirmPassword, prompt:
                        Text("••••••••").foregroundColor(Color.white.opacity(0.5))
                    )
                    .foregroundColor(.white)
                    .focused($focusedField, equals: .confirmPassword)
                    .onSubmit { focusedField = .none }
                } else {
                    SecureField("", text: $confirmPassword, prompt:
                        Text("••••••••").foregroundColor(Color.white.opacity(0.5))
                    )
                    .foregroundColor(.white)
                    .focused($focusedField, equals: .confirmPassword)
                    .onSubmit { focusedField = .none }
                }

                Spacer()

                // Eye icon toggles confirm password visibility
                Button(action: {
                    showConfirmPassword.toggle()
                }) {
                    Image(systemName: showConfirmPassword ? "eye" : "eye.slash")
                        .foregroundColor(Color.white.opacity(0.4))
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(.horizontal, 24)    }
    
    private var createAccountButton: some View {
        VStack(spacing: 15) {
            Button(action: {
                guard password == confirmPassword else {
                    alertTitle = "Passwords Don't Match"
                    alertMessage = "Please make sure both passwords are the same."
                    showAlert = true
                    return
                }
                Task {
                    do {
                        try await vm.signUp(
                            for: .init(
                                name: name,
                                email: email,
                                password: password,
                            )
                        )
                        // Reset router after successful sign up
                        await router.reset()
                    } catch {
                        await MainActor.run {
                            alertTitle = "Sign up failed"
                            alertMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                }
            }) {
                Text("Create Account")
                    .font(.system(size: 17, weight:.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color(red: 0.55, green: 0.35, blue: 0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            
            //Footer
            HStack(spacing: 4) {
                Text("Already have an account?").foregroundColor(Color.white.opacity(0.5))
                Button(action: {
                    router.navigate(to: .push(.login))
                }) {
                    Text("Log in").foregroundColor(Color(red: 0.55, green: 0.35, blue: 0.95))
                }
            }
            .font(.system(size: 14))
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 32)
    }
}

#Preview {
    SignUpView()
        .environment(AuthViewModel())

}
