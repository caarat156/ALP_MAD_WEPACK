//
//  TripDetailOverviewView.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import SwiftUI

struct TripDetailOverviewView: View {
    let trip: Trip
    var viewModel: TripViewModel
    
    // Data Dummy Anggota Kelompok sesuai dengan video demo WePack kamu
    let members = [
        (initials: "RF", name: "Rafi", role: "You", progress: 0.90, color: Color.blue),
        (initials: "ND", name: "Nadia", role: "Member", progress: 0.65, color: Color.teal),
        (initials: "DT", name: "Dito", role: "Member", progress: 0.60, color: Color.green),
        (initials: "KR", name: "Karina", role: "Member", progress: 0.85, color: Color.purple),
        (initials: "BM", name: "Bimo", role: "Member", progress: 0.40, color: Color.cyan)
    ]
    
    var body: some View {
        ZStack {
            // Background abu-abu ultra light khas Figma WePack
            Color(red: 0.96, green: 0.97, blue: 0.98)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // ==========================================
                    // 1. BANNER UTAMA TRIP DENGAN GAMBAR + OVERLAY
                    // ==========================================
                    ZStack(alignment: .bottomLeading) {
                        
                        // --- A. ASSET GAMBAR UTAMA ---
                        if let data = trip.customImage, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 180)
                                .clipped()
                        } else {
                            Image("bali_cover")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 180)
                                .clipped()
                        }
                        
                        // --- B. GRADASI GELAP PREMIUM ---
                        LinearGradient(
                            colors: [Color.black.opacity(0.2), Color.black.opacity(0.75)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        // --- C. KONTEN OVERLAY TEKS & TOMBOL ---
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("\(viewModel.calculateDaysAway(from: trip.startDate)) days away")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.black.opacity(0.4))
                                    .cornerRadius(20)
                                
                                Spacer()
                                
                                // Status Trip Owner/Member Dinamis
                                Text(trip.ownerId == viewModel.currentUserID ? "Owner" : "Member")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.28))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(10)
                            }
                            
                            Spacer()
                            
                            Text("ACTIVE TRIP")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.white.opacity(0.6))
                                .tracking(1)
                            
                            Text(trip.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "mappin.and.ellipse")
                                Text(trip.destination)
                                Text("•")
                                // Ambil rentang tanggal dinamis yang aman
                                Text(trip.destination.lowercased().contains("bali") ? "May 29 — Jun 2" : "Jun 15 — Jun 19")
                            }
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(20)
                    }
                    .frame(height: 180)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // ==========================================
                    // 2. KOTAK GROUP READINESS (68%)
                    // ==========================================
                    VStack(spacing: 16) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Group Readiness")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                                Text("\(members.count) members • synced live")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            
                            HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text("\(Int(trip.groupProgress * 100))")
                                    .font(.system(size: 32, weight: .black))
                                    .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                                Text("%")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                            }
                        }
                        
                        // Row Ringkasan Progress Lingkaran Anggota Kelompok
                        HStack(spacing: 0) {
                            ForEach(members, id: \.name) { member in
                                VStack(spacing: 6) {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.gray.opacity(0.15), lineWidth: 3)
                                            .frame(width: 42, height: 42)
                                        
                                        Circle()
                                            .trim(from: 0.0, to: CGFloat(member.progress))
                                            .stroke(member.color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                            .frame(width: 42, height: 42)
                                            .rotationEffect(Angle(degrees: -90))
                                        
                                        Text(member.initials)
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                                    }
                                    
                                    Text(member.name)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    Text("\(Int(member.progress * 100))%")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(18)
                    .padding(.horizontal)
                    
                    // ==========================================
                    // 3. STATISTIK BARANG
                    // ==========================================
                    HStack(spacing: 12) {
                        MiniStatCard(value: "12", label: "Items packed")
                        MiniStatCard(value: "10", label: "Remaining")
                        MiniStatCard(value: "4", label: "Days planned")
                    }
                    .padding(.horizontal)
                    
                    // ==========================================
                    // 4. DAY 2 PREVIEW (TIMELINE JALUR TIMELINE)
                    // ==========================================
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Day 2 Preview")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                            Spacer()
                            Button(action: {}) {
                                HStack(spacing: 4) {
                                    Text("See all")
                                        .font(.system(size: 13, weight: .bold))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 11, weight: .bold))
                                }
                                .foregroundColor(.blue)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            let day2Activities = viewModel.activities.filter { $0.tripId == trip.id }
                            
                            ForEach(day2Activities) { activity in
                                HStack(alignment: .top, spacing: 14) {
                                    Text(activity.startTimeString)
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                                        .frame(width: 45, alignment: .leading)
                                    
                                    Circle()
                                        .fill(activity.type == .transport ? Color.blue : (activity.type == .food ? Color.orange : Color.teal))
                                        .frame(width: 8, height: 8)
                                        .padding(.top, 5)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(activity.name)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                                        Text(activity.location)
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(18)
                    .padding(.horizontal)
                    
                    // ==========================================
                    // 5. SECTION "NEEDS ATTENTION"
                    // ==========================================
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Needs Attention")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                        
                        VStack(spacing: 12) {
                            AttentionRowComponent(initials: "ND", name: "Nadia", progress: 0.65, status: "IN PROGRESS", statusColor: .blue)
                            Divider().background(Color.gray.opacity(0.1))
                            AttentionRowComponent(initials: "DT", name: "Dito", progress: 0.60, status: "IN PROGRESS", statusColor: .blue)
                            Divider().background(Color.gray.opacity(0.1))
                            AttentionRowComponent(initials: "BM", name: "Bimo", progress: 0.40, status: "URGENT", statusColor: .red)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(18)
                    .padding(.horizontal)
                    .padding(.bottom, 25)
                }
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}

// --- SUB-KOMPONEN KUSTOM FORMAL AGAR KODE BERSIH DAN RAPI ---

struct MiniStatCard: View {
    var value: String
    var label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .black))
                .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct AttentionRowComponent: View {
    var initials: String
    var name: String
    var progress: Double
    var status: String
    var statusColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar Bundar
            Circle()
                .fill(Color(red: 0.08, green: 0.15, blue: 0.25).opacity(0.8))
                .frame(width: 36, height: 36)
                .overlay(
                    Text(initials)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                )
            
            // Nama Anggota
            Text(name)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                .frame(width: 60, alignment: .leading)
            
            // Mini Horizontal Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gray.opacity(0.15))
                    Capsule().fill(statusColor)
                        .frame(width: geo.size.width * CGFloat(progress))
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 4)
            
            Text("\(Int(progress * 100))%")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.gray)
                .frame(width: 35, alignment: .trailing)
            
            // Badge Status Kotak Kapsul (IN PROGRESS / URGENT)
            Text(status)
                .font(.system(size: 9, weight: .black))
                .foregroundColor(statusColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(statusColor.opacity(0.1))
                .cornerRadius(6)
        }
    }
}
