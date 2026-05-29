//
//  MemberPageView.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//
import SwiftUI

struct MemberPageView: View {
    // Memanggil ViewModel
    @StateObject private var viewModel = MemberPageViewModel()
    
    // State untuk memunculkan modal Add Member
    @State private var showAddMember = false
    @State private var selectedMember: MemberProgressUI? = nil
    
    let darkSlateBlue = Color(red: 37/255, green: 45/255, blue: 67/255)
    let lightGrayBg = Color(red: 248/255, green: 249/255, blue: 251/255)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                
                // --- TITLE & ADD MEMBER BUTTON ---
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Members")
                            .font(.system(size: 28, weight: .bold))
                        
                        Text("Bali Group Adventure • \(viewModel.members.count) members")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Tombol ini sekarang dijamin bisa diklik
                    Button(action: {
                        showAddMember = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus")
                            Text("Add Member")
                        }
                        .font(.subheadline.bold())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(darkSlateBlue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // --- GROUP READINESS CARD ---
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("GROUP READINESS")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("\(viewModel.groupReadinessPercentage)%")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("\(viewModel.membersAlmostReadyCount) of \(viewModel.members.count) members almost ready")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        Spacer()
                        
                        // Circular Indicator
                        ZStack {
                            Circle().stroke(Color.white.opacity(0.2), lineWidth: 8)
                            Circle()
                                .trim(from: 0.0, to: CGFloat(viewModel.groupReadinessPercentage) / 100.0)
                                .stroke(Color.teal, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                            
                            HStack(spacing: -8) {
                                ForEach(viewModel.members.prefix(3)) { member in
                                    Text(String(member.initials.prefix(1)))
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                        .background(Circle().fill(member.themeColor))
                                        .overlay(Circle().stroke(darkSlateBlue, lineWidth: 2))
                                }
                            }
                        }
                        .frame(width: 70, height: 70)
                    }
                    
                    // Progress Bar Bawah Card
                    HStack(spacing: 6) {
                        ForEach(viewModel.members) { member in
                            VStack(spacing: 4) {
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule().fill(Color.white.opacity(0.2))
                                        Capsule()
                                            .fill(Color.white)
                                            .frame(width: geo.size.width * CGFloat(member.progress))
                                    }
                                }
                                .frame(height: 6)
                                
                                Text(member.name)
                                    .font(.system(size: 9))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                }
                .padding(24)
                .background(
                    LinearGradient(gradient: Gradient(colors: [darkSlateBlue, Color(red: 65/255, green: 98/255, blue: 122/255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(16)
                .padding(.horizontal)
                
                // --- MEMBER GRID CARDS ---
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.members) { member in
                        // Bungkus Card dengan Button agar bisa ditekan
                        Button(action: {
                            selectedMember = member
                        }) {
                            MemberCardView(member: member)
                        }
                        .buttonStyle(PlainButtonStyle()) // Mencegah animasi teks menjadi biru berkedip khas tombol iOS
                    }
                }
                .padding(.horizontal)
                
//                // --- CATEGORY ASSIGNMENT SECTION ---
//                VStack(alignment: .leading, spacing: 0) {
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("Category Assignment")
//                            .font(.headline)
//                        Text("Who carries what")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                    .padding()
//                    
//                    Divider()
//                    
//                    ForEach(viewModel.categories) { category in
//                        CategoryRowView(category: category) // (Komponen UI dari jawaban sebelumnya)
//                        Divider()
//                    }
//                }
//                .background(Color.white)
//                .cornerRadius(16)
//                .padding(.horizontal)
//                .padding(.bottom, 20)
            }
        }
        .background(lightGrayBg)
        
        // 1. Sheet untuk memunculkan AddMemberView (Ini yang sebelumnya hilang)
        .sheet(isPresented: $showAddMember) {
            AddMemberView()
        }
        
        // 2. Sheet untuk memunculkan detail barang bawaan (MemberAssignedItemsView)
        .sheet(item: $selectedMember) { member in
            MemberAssignedItemsView(member: member)
        }
    }
}
// --- SUB-KOMPONEN: MEMBER CARD ---
struct MemberCardView: View {
    let member: MemberProgressUI
    
    var body: some View {
        VStack(spacing: 16) {
            // Garis Warna di Atas
            Rectangle()
                .fill(member.themeColor)
                .frame(height: 4)
            
            // Avatar & Cincin Progres
            ZStack {
                Circle().stroke(Color.gray.opacity(0.2), lineWidth: 5)
                Circle()
                    .trim(from: 0.0, to: CGFloat(member.progress))
                    .stroke(member.themeColor, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Text(member.initials)
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color(red: 37/255, green: 45/255, blue: 67/255)))
            }
            .frame(width: 60, height: 60)
            
            // Nama & YOU Badge
            VStack(spacing: 4) {
                Text(member.name).font(.headline)
                if member.isYou {
                    Text("YOU")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.teal)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.teal.opacity(0.15))
                        .cornerRadius(10)
                } else {
                    Text("").frame(height: 16) // Spacing filler
                }
            }
            
            // Item Count & Progress Bar
            VStack(spacing: 6) {
                HStack {
                    Text("\(member.packedItems)/\(member.totalItems) items")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(Int(member.progress * 100))%")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(member.themeColor)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.gray.opacity(0.2))
                        Capsule()
                            .fill(member.themeColor)
                            .frame(width: geo.size.width * CGFloat(member.progress))
                    }
                }
                .frame(height: 6)
            }
            .padding(.horizontal, 16)
            
            // Status Pill
            Text(member.statusText)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(member.themeColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(member.statusColor)
                .cornerRadius(12)
                .padding(.horizontal, 16)
            
            // Ikon Kecil di Bawah
            HStack(spacing: 8) {
                Image(systemName: "tshirt.fill").foregroundColor(.blue.opacity(0.5))
                Image(systemName: "powerplug.fill").foregroundColor(.black.opacity(0.7))
                Image(systemName: "pill.fill").foregroundColor(.red.opacity(0.7))
                Image(systemName: "list.clipboard.fill").foregroundColor(.gray)
            }
            .font(.caption2)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}
//
//// --- SUB-KOMPONEN: CATEGORY ROW ---
//struct CategoryRowView: View {
//    let category: CategoryAssignment
//    
//    var body: some View {
//        HStack(spacing: 16) {
//            // Ikon Kategori Bulat
//            Image(systemName: category.iconName)
//                .foregroundColor(category.iconColor)
//                .frame(width: 40, height: 40)
//                .background(Color.gray.opacity(0.1))
//                .clipShape(Circle())
//            
//            VStack(alignment: .leading, spacing: 6) {
//                HStack {
//                    Text(category.title).font(.subheadline.bold())
//                    Text("\(category.totalItems) items")
//                        .font(.system(size: 10, weight: .bold))
//                        .foregroundColor(.teal)
//                        .padding(.horizontal, 6)
//                        .padding(.vertical, 2)
//                        .background(Color.teal.opacity(0.1))
//                        .cornerRadius(6)
//                }
//                HStack(spacing: 8) {
//                    Text("\(category.everyoneCount) everyone")
//                    Text("\(category.customCount) custom")
//                }
//                .font(.system(size: 10, weight: .semibold))
//                .foregroundColor(.gray)
//                .padding(.horizontal, 8)
//                .padding(.vertical, 4)
//                .background(Color.gray.opacity(0.1))
//                .cornerRadius(10)
//            }
//            
//            Spacer()
//            
//            // Avatar yang ditugaskan
//            HStack(spacing: -6) {
//                ForEach(category.assignedInitials, id: \.self) { initial in
//                    Text(initial)
//                        .font(.system(size: 10, weight: .bold))
//                        .foregroundColor(.white)
//                        .frame(width: 24, height: 24)
//                        .background(Circle().fill(Color(red: 65/255, green: 98/255, blue: 122/255)))
//                        .overlay(Circle().stroke(Color.white, lineWidth: 1.5))
//                }
//            }
//        }
//        .padding()
//    }
//}

#Preview {
    MemberPageView()
}
