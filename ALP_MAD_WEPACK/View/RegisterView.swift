//
//  RegisterView.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import SwiftUI
struct RegisterView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    let backgroundNavy = Color(red: 44/255, green: 74/255, blue: 104/255)
    let buttonNavy = Color(red: 45/255, green: 68/255, blue: 97/255)
    
    var body: some View {
        ZStack {
            backgroundNavy
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                HStack(spacing: 12) {
                    Text("W")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                    
                    Text("WePack")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .padding(.bottom, 25)
                
                VStack(alignment: .leading, spacing: 18) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Text("Create account")
                                .font(.system(size: 28, weight: .bold))
                            Text("✨")
                                .font(.system(size: 24))
                        }
                        
                        Text("It's free and only takes a minute")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    .padding(.top, 5)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            
                            AuthInputField(
                                label: "FULL NAME",
                                text: $authViewModel.registerName,
                                placeholder: "Rafi Pratama",
                                isSecure: false
                            )
                            
                            VStack(alignment: .leading, spacing: 6) {
                                AuthInputField(
                                    label: "USERNAME *",
                                    text: $authViewModel.registerUsername,
                                    placeholder: "@ rafipratama",
                                    isSecure: false
                                )
                                
                                Text("Friends can find and invite you using your @username")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray.opacity(0.7))
                                    .padding(.leading, 4)
                            }
                            
                            AuthInputField(
                                label: "EMAIL",
                                text: $authViewModel.registerEmail,
                                placeholder: "rafi@example.com",
                                isSecure: false
                            )
                            
                            AuthInputField(
                                label: "PASSWORD",
                                text: $authViewModel.registerPassword,
                                placeholder: "Min. 8 characters",
                                isSecure: true
                            )
                            
                            AuthInputField(
                                label: "CONFIRM PASSWORD",
                                text: $authViewModel.registerConfirmPassword,
                                placeholder: "Repeat password",
                                isSecure: true
                            )
                        }
                        .padding(.vertical, 2)
                    }
                    .frame(maxHeight: 380)
                    
                    Button(action: {
                        authViewModel.register()
                    }) {
                        HStack {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Create Account")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(authViewModel.isRegisterValid ? buttonNavy : buttonNavy.opacity(0.6))
                        .cornerRadius(16)
                    }
                    .disabled(!authViewModel.isRegisterValid || authViewModel.isLoading)
                    .padding(.top, 5)
                    
                    HStack(spacing: 4) {
                        Spacer()
                        Text("Already have an account?")
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Sign In")
                                .fontWeight(.bold)
                                .foregroundColor(buttonNavy)
                        }
                        Spacer()
                    }
                    .font(.subheadline)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 30)
                .background(Color.white)
                .cornerRadius(32)
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true) 
    }
}
#Preview {
    NavigationStack {
        RegisterView(authViewModel: AuthViewModel())
    }
}
