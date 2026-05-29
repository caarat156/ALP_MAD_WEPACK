//
//  AuthInputField.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import SwiftUI
struct AuthInputField: View {
    var label: String
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool
    
    // State internal khusus untuk menyalakan/menyembunyikan password text
    @State private var isPasswordSecured: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Label teks kecil abu-abu di atas kotak input
            Text(label)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.gray.opacity(0.7))
                .padding(.leading, 4)
            
            HStack {
                if isSecure && isPasswordSecured {
                    SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray.opacity(0.3)))
                        .font(.system(size: 15))
                } else {
                    TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray.opacity(0.3)))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.system(size: 15))
                }
                
                // Jika tipenya field password, munculkan ikon mata di sebelah kanan kotak
                if isSecure {
                    Button(action: {
                        isPasswordSecured.toggle()
                    }) {
                        Image(systemName: isPasswordSecured ? "eye" : "eye.slash")
                            .foregroundColor(.gray.opacity(0.6))
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(red: 247/255, green: 249/255, blue: 252/255)) // Warna background kotak agak keabuan soft
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.12), lineWidth: 1)
            )
        }
    }
}
