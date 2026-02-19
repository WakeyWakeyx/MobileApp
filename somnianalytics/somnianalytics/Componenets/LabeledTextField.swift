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
    // Icon for each text field
    var icon: String? = nil

    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.white.opacity(0.7))
            
            // Input box
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(Color.white.opacity(0.4))
                }
                if isSecure {
                    SecureField(placeholder, text: $text, prompt:
                                    Text(placeholder).foregroundColor(Color.white.opacity(0.5))
                                )
                        .foregroundColor(.white)
                        .keyboardType(inputType)
                }
                else {
                    TextField(placeholder, text: $text, prompt:
                                Text(placeholder).foregroundColor(Color.white.opacity(0.5))
                            )
                        .foregroundColor(.white)
                        .keyboardType(inputType)
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

#Preview {
    @Previewable @State var previewText = ""
    LabeledTextField(label: "Testing", text: $previewText, placeholder: "please work", inputType: .default, isSecure: false)
}
