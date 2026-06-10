//
//  AccountView.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import SwiftUI
import PhotosUI

struct AccountView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = AccountViewModel()
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 247/255, blue: 250/255)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                // Di iPad, konten di-center dengan max width
                VStack(spacing: 20) {
                    
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 16) {
                            
                            PhotosPicker(selection: $viewModel.selectedPhotoItem, matching: .images) {
                                ZStack(alignment: .bottomTrailing) {
                                    Group {
                                        if let profileImage = viewModel.profileImage {
                                            Image(uiImage: profileImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: sizeClass == .regular ? 100 : 80,
                                                       height: sizeClass == .regular ? 100 : 80)
                                                .clipShape(Circle())
                                        } else {
                                            Text(viewModel.avatarInitials)
                                                .font(sizeClass == .regular ? .largeTitle : .title)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .frame(width: sizeClass == .regular ? 100 : 80,
                                                       height: sizeClass == .regular ? 100 : 80)
                                                .background(Color.gray)
                                                .clipShape(Circle())
                                        }
                                    }
                                    
                                    Image(systemName: "camera.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                        .background(Color.white.clipShape(Circle()))
                                }
                            }
                            .buttonStyle(.plain)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.name)
                                    .font(sizeClass == .regular ? .title2 : .title3)
                                    .fontWeight(.bold)
                                Text(viewModel.username)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(viewModel.email)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    AccountSectionView(title: "General") {
                        NavigationLink(destination: EditAccountView(viewModel: viewModel)) {
                            AccountMenuRowView(icon: "person.circle", iconColor: .blue, title: "Edit Profile", subtitle: "Change your name or password")
                        }
                        .buttonStyle(.plain)
                        
                        Divider().padding(.leading, 56)
                        
                        AccountMenuRowView(icon: "bell", iconColor: .orange, title: "Notifications", subtitle: "Manage your alerts")
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        HStack {
                            Spacer()
                            Text("Logout")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                }
                .padding(.vertical)
                // Batasi lebar konten di iPad agar tidak terlalu melebar
                .frame(maxWidth: sizeClass == .regular ? 600 : .infinity)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct AccountSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .padding(.leading, 8)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
        }
    }
}

struct AccountMenuRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(16)
        .contentShape(Rectangle())
    }
}

#Preview {
    AccountView(authViewModel: AuthViewModel())
}
