//
//  AccountView.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import SwiftUI
struct AccountView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = AccountViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background abu-abu sangat muda (seperti di foto referensi)
                Color(red: 245/255, green: 247/255, blue: 250/255)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // --- 1. PROFILE CARD (Header Navy) ---
                        VStack(spacing: 0) {
                            // Bagian Atas: Navy Blue + Avatar + Nama
                            HStack(alignment: .top, spacing: 16) {
                                // Avatar
                                Group {
                                    if let profileImage = viewModel.profileImage {
                                        Image(uiImage: profileImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                    } else {
                                        Text(viewModel.avatarInitials)
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 80, height: 80)
                                            .background(Color(red: 100/255, green: 130/255, blue: 155/255)) // Warna inisial
                                            .clipShape(Circle())
                                    }
                                }
                                
                                // Info User
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(viewModel.name)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                        Spacer()
                                        
                                        // Tombol Edit Profile transparan
                                        Button(action: {
                                            viewModel.prepareEditForm()
                                            viewModel.showEditSheet.toggle()
                                        }) {
                                            Text("Edit Profile")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.white.opacity(0.2))
                                                .cornerRadius(20)
                                        }
                                    }
                                    
                                    Text(viewModel.email)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                        .lineLimit(1)
                                    
                                    Text("@\(viewModel.username) · \n\(viewModel.bio)")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                        .lineLimit(2)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                            .padding(.bottom, 20)
                            .background(Color(red: 50/255, green: 80/255, blue: 110/255)) // Warna Navy Header
                            
                            // Garis Pembatas
                            Divider().background(Color.white.opacity(0.3))
                            
                            // Bagian Bawah: Stats (3 Kolom)
                            HStack(spacing: 0) {
                                StatColumnView(value: "\(viewModel.totalTrips)", label: "Trips")
                                Divider().background(Color.white.opacity(0.3)).frame(height: 40)
                                StatColumnView(value: "5", label: "Members") // Hardcoded ikut foto referensi, nanti bisa disesuaikan
                                Divider().background(Color.white.opacity(0.3)).frame(height: 40)
                                StatColumnView(value: "\(viewModel.totalItemsPacked)", label: "Items Packed")
                            }
                            .padding(.vertical, 16)
                            .background(Color(red: 65/255, green: 100/255, blue: 130/255)) // Warna Navy Bawah agak muda
                        }
                        .cornerRadius(20)
                        .padding(.horizontal, 16)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                        
                        
                        // --- 2. CURRENT TRIP CARD ---
                        HStack {
                            Image("bali_temple") // Pastikan ada gambar bernama 'bali_temple' di Assets, kalau tidak bisa diganti ikon
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Bali Group Adventure")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("Jun 14–17, 2026 · 5 members · 68% ready")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 16)
                        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
                        
                        // --- 3. MENU SECTIONS ---
                        VStack(spacing: 24) {
                            
                            // PREFERENCES
                            MenuSectionView(title: "PREFERENCES") {
                                MenuRowView(icon: "bell", iconColor: .gray, title: "Notifications", subtitle: "Trip reminders & updates")
                                Divider().padding(.leading, 50)
                                MenuRowView(icon: "applewatch", iconColor: .gray, title: "Apple Watch Sync", subtitle: "Hands-free packing mode")
                                Divider().padding(.leading, 50)
                                MenuRowView(icon: "globe", iconColor: .gray, title: "Language & Region", subtitle: "Bahasa Indonesia")
                            }
                            
                            // PRIVACY & SUPPORT
                            MenuSectionView(title: "PRIVACY & SUPPORT") {
                                MenuRowView(icon: "shield", iconColor: .gray, title: "Privacy & Security", subtitle: "Data & permissions")
                                Divider().padding(.leading, 50)
                                MenuRowView(icon: "questionmark.circle", iconColor: .gray, title: "Help & Support", subtitle: "FAQs, contact us")
                                Divider().padding(.leading, 50)
                                MenuRowView(icon: "doc.text", iconColor: .gray, title: "Terms of Service", subtitle: "Legal information")
                            }
                            
                            // SIGN OUT BUTTON
                            Button(action: {
                                authViewModel.logout() // Memanggil fungsi logout Firebase
                            }) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Text("Sign Out")
                                }
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
                            }
                            
                            // FOOTER
                            Text("WePack v1.0.0 · Made with ❤️ for travelers")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 32)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                        Text("Bali Group Adventure")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        Image(systemName: "bell")
                            .foregroundColor(.gray)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                        
                        Text("RF")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(Color(red: 50/255, green: 80/255, blue: 110/255))
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(isPresented: $viewModel.showEditSheet) {
                EditAccountView(viewModel: viewModel)
            }
        }
    }
}
// MARK: - Subviews untuk menyederhanakan kode
// View untuk kolom statistik di dalam Profile Card
struct StatColumnView: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}
// View untuk kotak Menu Section (Header + Card Putih)
struct MenuSectionView<Content: View>: View {
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
// View untuk setiap baris di dalam Menu
struct MenuRowView: View {
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
        .onTapGesture {
            // Aksi per menu jika dibutuhkan
        }
    }
}
#Preview {
    AccountView(authViewModel: AuthViewModel())
}
