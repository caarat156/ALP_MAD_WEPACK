//
//  LoginView.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import SwiftUI
struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var isShowingRegister = false
    
    // Warna Background Navy Utama (Menyesuaikan foto mockup kamu)
    let backgroundNavy = Color(red: 44/255, green: 74/255, blue: 104/255)
    // Warna Tombol Sign In (Lebih gelap)
    let buttonNavy = Color(red: 45/255, green: 68/255, blue: 97/255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                // --- 1. BACKGROUND FULL NAVY ---
                backgroundNavy
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // --- 2. TOP BRANDING (LOGO & APPS NAME) ---
                    HStack(spacing: 12) {
                        // Lingkaran abu-abu transparan dengan huruf "W"
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
                    .padding(.bottom, 30)
                    
                    // --- 3. WHITE CONTAINER (BOX UTAMA) ---
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Greeting Texts
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Text("Welcome back")
                                    .font(.system(size: 28, weight: .bold))
                                Text("👋")
                                    .font(.system(size: 26))
                            }
                            
                            Text("Sign in to your WePack account")
                                .font(.subheadline)
                                .foregroundColor(.gray.opacity(0.8))
                        }
                        .padding(.top, 10)
                        
                        // Input Fields (Email & Password)
                        VStack(spacing: 16) {
                            AuthInputField(
                                label: "EMAIL",
                                text: $authViewModel.loginEmail,
                                placeholder: "rafi.pratama@gmail.com",
                                isSecure: false
                            )
                            
                            // Ditambahkan fitur Forgot Password di atas field password
                            VStack(alignment: .trailing, spacing: 4) {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        // Action forgot password
                                    }) {
                                        Text("Forgot password?")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(red: 50/255, green: 90/255, blue: 130/255))
                                    }
                                }
                                
                                AuthInputField(
                                    label: "PASSWORD",
                                    text: $authViewModel.loginPassword,
                                    placeholder: "••••••••",
                                    isSecure: true
                                )
                            }
                        }
                        
                        // Error Message jika ada
                        if let error = authViewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        // Sign In Button
                        Button(action: {
                            authViewModel.login()
                        }) {
                            HStack {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Sign In")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(authViewModel.isLoginValid ? buttonNavy : buttonNavy.opacity(0.6))
                            .cornerRadius(16)
                        }
                        .disabled(!authViewModel.isLoginValid || authViewModel.isLoading)
                        .padding(.top, 5)
                        
                        // Footer: Register Link
                        HStack(spacing: 4) {
                            Spacer()
                            Text("Don't have an account?")
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                isShowingRegister = true
                            }) {
                                Text("Register")
                                    .fontWeight(.bold)
                                    .foregroundColor(buttonNavy)
                            }
                            Spacer()
                        }
                        .font(.subheadline)
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)
                    .background(Color.white)
                    .cornerRadius(32) // Membuat sudut kotak putih melengkung cantik sesuai foto
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $isShowingRegister) {
                RegisterView(authViewModel: authViewModel)
            }
        }
    }
}
#Preview {
    LoginView(authViewModel: AuthViewModel())
}
