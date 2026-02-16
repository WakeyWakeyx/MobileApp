//
//  DestinationViewMapping.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/15/26.
//

import SwiftUI


@ViewBuilder func view(for destination: PushDestination) -> some View {
    switch destination {
    case .login:
        LoginView()
    case .signUp:
        SignUpView()
    }
}

// Can add this functionality when we need sheets, currently we don't 
//@ViewBuilder func view(for destination: SheetDestination) -> some View {
//    Group {
//        switch destination {
//        case .sleepDetails(id):
//            
//        }
//    }
//    .navigationBarTitleDisplayMode(.inline)
//    .presentationBackground(.regularMaterial)
//}
