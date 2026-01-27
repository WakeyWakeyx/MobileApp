//
//  AuthEntryView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/27/26.
//

import SwiftUI

// TODO: THIS PAGE WILL NEED ROUTING SET UP AND THEN WE WILL PROGRAMMATICALLY SEND THE USER TO EACH PAGE BASED ON THE BUTTON THEY CLICK ON 
struct AuthEntryView: View {
    var body: some View {
        VStack {
            Spacer()
            header
            Spacer()
            Text("Welcome Back")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
            
            authFlowButtons
            Spacer()
        }
    }
    
    private var header: some View{
        Text("Somni Analytics")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
            .padding()
    }
    
    
    
    @ViewBuilder
    private var authFlowButtons: some View {
        VStack {
            Button(action: {
                // TODO: MAKE THIS GO TO THE SIGN IN PAGE
            }) {
                Spacer()
                Text("Sign In")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()
                Spacer()
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.blue.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding()
            
            Button(action: {
                // TODO: MAKE THIS GO TO THE SIGN UP PAGE
            }) {
                Spacer()
                Text("Sign Up")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()
                    .foregroundStyle(Color.white)
                Spacer()
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding()
        }
    }
}

#Preview {
    AuthEntryView()
}
