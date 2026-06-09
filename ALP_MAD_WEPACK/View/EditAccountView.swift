//
//  EditAccountView.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import SwiftUI
import PhotosUI

struct EditAccountView: View {
    @ObservedObject var viewModel: AccountViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var sizeClass

    let navyColor = Color(red: 50/255, green: 80/255, blue: 110/255)

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Edit Profile")
                    .font(.title3)
                    .fontWeight(.bold)

                Spacer()

                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.4))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 10)

            ScrollView(showsIndicators: false) {
                // Batasi lebar form di iPad
                VStack(spacing: 25) {

                    VStack(spacing: 12) {
                        PhotosPicker(selection: $viewModel.selectedPhotoItem, matching: .images) {
                            ZStack(alignment: .bottomTrailing) {
                                if let profileImage = viewModel.profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: sizeClass == .regular ? 120 : 100,
                                               height: sizeClass == .regular ? 120 : 100)
                                        .clipShape(Circle())
                                } else {
                                    Text(viewModel.avatarInitials)
                                        .font(.system(size: sizeClass == .regular ? 48 : 40, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: sizeClass == .regular ? 120 : 100,
                                               height: sizeClass == .regular ? 120 : 100)
                                        .background(navyColor)
                                        .clipShape(Circle())
                                }

                                Image(systemName: "camera.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                    .background(Color(red: 70/255, green: 100/255, blue: 130/255))
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            }
                        }

                        Text("Tap to change photo")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)

                    // Di iPad pakai 2-kolom untuk field input
                    if sizeClass == .regular {
                        VStack(spacing: 18) {
                            HStack(spacing: 16) {
                                CustomInputField(label: "FULL NAME", text: $viewModel.editedName)
                                CustomInputField(label: "USERNAME", text: $viewModel.editedUsername, prefix: "@")
                            }
                            HStack(spacing: 16) {
                                CustomInputField(label: "EMAIL", text: $viewModel.editedEmail)
                                CustomInputField(label: "PHONE NUMBER", text: $viewModel.editedPhone)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("BIO")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 4)

                                TextEditor(text: $viewModel.editedBio)
                                    .padding(12)
                                    .frame(height: 100)
                                    .background(Color(red: 245/255, green: 247/255, blue: 250/255))
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                                    )
                            }
                        }
                    } else {
                        // iPhone: 1 kolom seperti semula
                        VStack(spacing: 18) {
                            CustomInputField(label: "FULL NAME", text: $viewModel.editedName)
                            CustomInputField(label: "USERNAME", text: $viewModel.editedUsername, prefix: "@")
                            CustomInputField(label: "EMAIL", text: $viewModel.editedEmail)
                            CustomInputField(label: "PHONE NUMBER", text: $viewModel.editedPhone)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("BIO")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 4)

                                TextEditor(text: $viewModel.editedBio)
                                    .padding(12)
                                    .frame(height: 100)
                                    .background(Color(red: 245/255, green: 247/255, blue: 250/255))
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.horizontal, sizeClass == .regular ? 32 : 0)
                .padding(.bottom, 30)
                .frame(maxWidth: sizeClass == .regular ? 640 : .infinity)
                .frame(maxWidth: .infinity)
            }

            HStack(spacing: 15) {
                Button(action: { dismiss() }) {
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                }

                Button(action: {
                    viewModel.saveProfile()
                    dismiss()
                }) {
                    Text("Save Changes")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(navyColor)
                        .cornerRadius(15)
                }
                .disabled(viewModel.editedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(viewModel.editedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1.0)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            .padding(.top, 10)
            .background(Color.white)
            .frame(maxWidth: sizeClass == .regular ? 640 : .infinity)
            .frame(maxWidth: .infinity)
        }
    }
}

struct CustomInputField: View {
    var label: String
    @Binding var text: String
    var prefix: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .padding(.leading, 4)

            HStack {
                if let prefix = prefix {
                    Text(prefix)
                        .foregroundColor(.primary)
                        .fontWeight(.medium)
                }

                TextField("", text: $text)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color(red: 245/255, green: 247/255, blue: 250/255))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

#Preview {
    EditAccountView(viewModel: AccountViewModel())
}
