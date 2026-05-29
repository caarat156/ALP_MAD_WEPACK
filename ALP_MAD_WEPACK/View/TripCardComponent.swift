//
//  TripCardComponent.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import SwiftUI

struct TripCardComponent: View {
    let trip: Trip
    var viewModel: TripViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Bagian Atas Card (Visual Banner dengan Gradient)
            ZStack(alignment: .top) {
                LinearGradient(colors: [Color(red: 0.15, green: 0.30, blue: 0.50), Color.black.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: 130)
//                    .cornerRadius(16, corners: [.topLeft, .topRight])
                
                HStack {
                    // Logika penanda Owner Trip berdasarkan OwnerID di MockData
                    Text(trip.ownerId == "USER_CACA_123" ? "Owner" : "Member")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(12)
                    Spacer()
                    
                    Text("Upcoming")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(12)
                }
                .padding(12)
                
                VStack {
                    Spacer()
                    HStack {
                        Text(trip.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(16)
                }
            }
            
            // Bagian Bawah Card (Informasi Detail Teknis)
            VStack(spacing: 12) {
                HStack {
                    Label(trip.destination, systemImage: "mappin.and.ellipse")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Spacer()
                    Label(trip.dateRangeString, systemImage: "calendar")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                HStack(spacing: 12) {
                    Label("\(trip.memberIds.count) members", systemImage: "person.2.fill")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                    
                    // Linear Progress Bar untuk Kelompok
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.gray.opacity(0.15))
                            Capsule().fill(LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing))
                                .frame(width: geo.size.width * CGFloat(trip.groupProgress))
                        }
                    }
                    .frame(height: 8)
                    
                    Text("\(Int(trip.groupProgress * 100))%")
                        .font(.system(size: 13, weight: .bold))
                    
                    // Menampilkan perhitungan hari mundur otomatis dari komputer/HP
                    Text("\(viewModel.calculateDaysAway(from: trip.startDate))d away")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(6)
                }
            }
            .padding(16)
            .background(Color.white)
//            .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
        }
        .padding(.horizontal)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}
