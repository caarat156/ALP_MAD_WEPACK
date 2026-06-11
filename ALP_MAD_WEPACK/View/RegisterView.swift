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
    @Environment(\.horizontalSizeClass) var sizeClass

    let backgroundNavy = Color(red: 44/255, green: 74/255, blue: 104/255)
    let buttonNavy = Color(red: 45/255, green: 68/255, blue: 97/255)

    var body: some View {
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

                        Text("Your trip,\nyour crew,\nall packed.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)

                    // Kanan — form register
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
                    .padding(.bottom, 25)

                    formCard
                        .padding(.horizontal, 16)

                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var formCard: some View {
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
                            placeholder: "rafipratama",
                            isSecure: false,
                            prefix: "@"
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
            .frame(maxHeight: sizeClass == .regular ? 320 : 380)

            if let error = authViewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

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
    }
}

#Preview {
    NavigationStack {
        RegisterView(authViewModel: AuthViewModel())
    }
}
