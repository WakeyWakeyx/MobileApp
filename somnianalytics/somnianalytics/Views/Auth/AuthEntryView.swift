//
//  AuthEntryView.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/27/26.
//

import SwiftUI
 
struct AuthEntryView: View {
    @Environment(Router.self) private var router: Router
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
                center: .bottom,
                startRadius: 10,
                endRadius: 700
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
            Spacer()
            header
            Spacer()
            authFlowButtons
            }
        }
    }
    
    private var header: some View{
        // 15 points btw each vertical element
        VStack(spacing: 15) {
            
            ZStack {
                // App icon
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous)
                    .fill(Color(red: 0.55, green: 0.35, blue: 0.95))
                    .frame(width: 100, height: 100)
                
                // Moon logo
                Image(systemName: "moon.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 40)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 15)
            
            Text("SleepSmart")
                .font(.system(size: 45, weight: .bold))
                .foregroundColor(.white)
            
            Text("Optimize your wake-up timing for\npeak performance")
                .font(.system(size: 17))
                .foregroundColor(Color.white.opacity(0.55))
                //align text in center
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
        }
    }
    
    
    @ViewBuilder
    private var authFlowButtons: some View {
        VStack(spacing: 12) {
            // Sign up button
            Button(action: {
                router.navigate(to: .push(.signUp))
            }) {
                HStack {
                    Text("Get Started")
                        .font(.system(size: 17, weight: .bold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color(red: 0.55, green: 0.35, blue: 0.95))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            
            // Sign in button
            Button(action: {
                router.navigate(to: .push(.login))
            }) {
                Text("Sign In")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 32)
    }
}

#Preview {
    AuthEntryView()
        .environment(Router(level: 0, identifierTab: nil))
}
