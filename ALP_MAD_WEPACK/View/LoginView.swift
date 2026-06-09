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
    @Environment(\.horizontalSizeClass) var sizeClass

    let backgroundNavy = Color(red: 44/255, green: 74/255, blue: 104/255)
    let buttonNavy = Color(red: 45/255, green: 68/255, blue: 97/255)

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundNavy
                    .ignoresSafeArea()

                if sizeClass == .regular {
                    // ===========================
                    // iPad: 2-kolom layout
                    // ===========================
                    HStack(spacing: 0) {
                        // Kiri — branding panel
                        VStack(spacing: 24) {
                            Spacer()
                            Image(systemName: "backpack.fill")
                                .font(.system(size: 72))
                                .foregroundColor(.white.opacity(0.9))

                            Text("WePack")
                                .font(.system(size: 42, weight: .black, design: .rounded))
                                .foregroundColor(.white)

                            Text("Pack smarter,\ntravel together.")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.7))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)

                        // Kanan — form login
                        VStack {
                            Spacer()
                            formCard
                                .frame(maxWidth: 460)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                } else {
                    // ===========================
                    // iPhone: layout vertikal
                    // ===========================
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
                        .padding(.bottom, 30)

                        formCard
                            .padding(.horizontal, 16)

                        Spacer()
                    }
                }
            }
            .navigationDestination(isPresented: $isShowingRegister) {
                RegisterView(authViewModel: authViewModel)
            }
        }
    }

    // Form card yang dipakai di kedua layout
    private var formCard: some View {
        VStack(alignment: .leading, spacing: 20) {

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

            VStack(spacing: 16) {
                AuthInputField(
                    label: "EMAIL",
                    text: $authViewModel.loginEmail,
                    placeholder: "rafi.pratama@gmail.com",
                    isSecure: false
                )

                VStack(alignment: .trailing, spacing: 4) {
                    HStack {
                        Spacer()
                        Button(action: {}) {
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

            if let error = authViewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

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
        .cornerRadius(32)
    }
}

#Preview {
    LoginView(authViewModel: AuthViewModel())
}
