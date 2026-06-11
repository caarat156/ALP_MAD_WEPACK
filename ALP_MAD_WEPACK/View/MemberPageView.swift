//
//  MemberPageView.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct MemberPageView: View {
    @StateObject private var viewModel = MemberPageViewModel()
    @ObservedObject var packingViewModel: PackingViewModel
    
    // 📢 1. Tambahkan ini agar layar tahu ID aslimu
    var tripViewModel: TripViewModel
    
    // 💡 PENAMBAHAN 1: Variabel untuk menerima data trip dari halaman sebelumnya
    var tripId: String
    var tripName: String
    var tripDate: String
    
    @State private var showAddMember = false
    @State private var selectedMember: MemberProgressUI? = nil
    
    let darkSlateBlue = Color(red: 37/255, green: 45/255, blue: 67/255)
    let lightGrayBg = Color(red: 248/255, green: 249/255, blue: 251/255)
    
    var syncedMembers: [MemberProgressUI] {
        let colors: [Color] = [.teal, .blue, .orange, .purple, .pink]
        
        return packingViewModel.tripMembers.enumerated().map { index, tripMember in
            let assignedItems = packingViewModel.packingItems.filter {
                $0.assignedTo.contains(tripMember.id) || $0.assignedTo.contains("Everyone")
            }
            
            let liveTotalItems = assignedItems.count
            let livePackedItems = assignedItems.filter { $0.isPacked }.count
            
            let cleanName = tripMember.name.replacingOccurrences(of: " (You)", with: "")
            let initials = cleanName.isEmpty ? "?" : String(cleanName.prefix(2)).uppercased()
            
            // 📢 2. KUNCI PERBAIKANNYA DI SINI!
            // Kita cocokkan ID member dengan currentUserID kamu yang asli
            let isYou = tripMember.id == tripViewModel.currentUserID || tripMember.id == "me"
            
            return MemberProgressUI(
                id: tripMember.id,
                name: cleanName,
                initials: initials,
                isYou: isYou,
                packedItems: livePackedItems,
                totalItems: liveTotalItems,
                themeColor: colors[index % colors.count]
            )
        }
    }
    
    var syncedReadyCount: Int {
        syncedMembers.filter { $0.progress >= 1.0 }.count
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                headerSection
                progressSection
                memberGridSection
            }
        }
        .background(lightGrayBg)
        .sheet(isPresented: $showAddMember) {
            // 💡 PENAMBAHAN 2: Gunakan variabel yang sudah dilempar dari atas
            AddMemberView(tripId: tripId, tripName: tripName, tripDate: tripDate)
        }
        .sheet(item: $selectedMember) { member in
            // 📢 1. Lempar packingViewModel ke dalam layar detail barang
            MemberAssignedItemsView(
                member: member,
                packingViewModel: packingViewModel
            )
        }
    }
    
    // MARK: - Subviews
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Members")
                    .font(.system(size: 28, weight: .bold))
                
                // 💡 PENAMBAHAN 3: Nama trip sekarang dinamis, bukan hardcode "Bali Group Adventure" lagi
                Text("\(tripName) • \(syncedMembers.count) members")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: { showAddMember = true }) {
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
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("GROUP READINESS")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(packingViewModel.progressPercentage)%")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("\(syncedReadyCount) of \(syncedMembers.count) members ready")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                Spacer()
                
                ZStack {
                    Circle().stroke(Color.white.opacity(0.2), lineWidth: 8)
                    Circle()
                        .trim(from: 0.0, to: CGFloat(packingViewModel.progressPercentage) / 100.0)
                        .stroke(Color.teal, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    
                    HStack(spacing: -8) {
                        ForEach(syncedMembers.prefix(3)) { member in
                            Text(member.initials.prefix(1))
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
            
            HStack(spacing: 6) {
                ForEach(syncedMembers) { member in
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
                            .lineLimit(1)
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
    }
    
    private var memberGridSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(syncedMembers) { member in
                Button(action: {
                    selectedMember = member
                }) {
                    MemberCardView(member: member)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - MemberCardView Component
struct MemberCardView: View {
    let member: MemberProgressUI
    
    var body: some View {
        VStack(spacing: 16) {
            Rectangle()
                .fill(member.themeColor)
                .frame(height: 4)
            
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
            
            VStack(spacing: 4) {
                Text(member.name).font(.headline).lineLimit(1)
                if member.isYou {
                    Text("YOU")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.teal)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.teal.opacity(0.15))
                        .cornerRadius(10)
                } else {
                    Text("").frame(height: 16)
                }
            }
            
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
            
            Text(member.statusText)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(member.themeColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(member.statusColor)
                .cornerRadius(12)
                .padding(.horizontal, 16)
            
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
