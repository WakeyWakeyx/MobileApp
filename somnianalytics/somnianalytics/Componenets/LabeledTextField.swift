//
//  LabeledTextField.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 1/26/26.
//

import SwiftUI

struct LabeledTextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var inputType: UIKeyboardType = .default
    var isSecure: Bool = false
    var body: some View {
        VStack(alignment: .leading){
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .padding(.horizontal)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.1),radius: 2)
                    .keyboardType(inputType)
            }
            else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.1), radius: 2)
                    .keyboardType(inputType)
            }
                            
        }
    }
}

#Preview {
    @Previewable @State var previewText = ""
    LabeledTextField(label: "Testing", text: $previewText, placeholder: "please work", inputType: .default, isSecure: false)
}
