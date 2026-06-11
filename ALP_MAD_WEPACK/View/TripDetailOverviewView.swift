//
//  TripDetailOverviewView.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import SwiftUI

struct TripDetailOverviewView: View {
    let trip: Trip
    var tripViewModel: TripViewModel
    var activityViewModel: ActivityViewModel
    
    // 📢 1. Inject ViewModel yang menangani data packing
    @ObservedObject var packingViewModel: PackingViewModel

    @Environment(\.horizontalSizeClass) var sizeClass
    
    // 📢 2. Computed Properties untuk menghitung statistik barang otomatis
        var packedItemsCount: Int {
            // Pakai packingItems sesuai dengan nama di PackingViewModel
            packingViewModel.packingItems.filter { $0.tripId == trip.id && $0.isPacked }.count
        }
        
        var totalItemsCount: Int {
            // Pakai packingItems sesuai dengan nama di PackingViewModel
            packingViewModel.packingItems.filter { $0.tripId == trip.id }.count
        }
        
        var remainingItemsCount: Int {
            totalItemsCount - packedItemsCount
        }
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.97, blue: 0.98).ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. BANNER STATIS
                    ZStack(alignment: .bottomLeading) {
                        Image("bali_cover")
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 180)
                            .clipped()
                    }
                    .cornerRadius(20)

                    // 2. GROUP READINESS
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Group Readiness").font(.headline)
                                Text("\(trip.memberIds.count) members • synced live")
                                    .font(.caption).foregroundColor(.gray)
                            }
                            Spacer(minLength: 0)
                            
                            // Menghitung progress keseluruhan grup berdasarkan barang yang di-pack
                            let overallProgress = totalItemsCount > 0 ? (Double(packedItemsCount) / Double(totalItemsCount)) * 100 : 0.0
                            Text("\(Int(overallProgress))%").font(.title.bold())
                        }
                        
//                        HStack {
//                            Text("IDs: " + trip.memberIds.joined(separator: ", "))
//                                .font(.system(size: 14, weight: .medium))
//                                .foregroundColor(.gray)
//                                .lineLimit(1)
//                                .truncationMode(.tail)
//                            Spacer(minLength: 0)
//                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(18)
                    
                    // 3. STATISTIK BARANG (Sudah Dinamis)
                    HStack(spacing: 10) {
                        MiniStatCard(value: "\(packedItemsCount)", label: "Items packed")
                        MiniStatCard(value: "\(remainingItemsCount)", label: "Remaining")
                        
                        let totalDays = (Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: trip.startDate), to: Calendar.current.startOfDay(for: trip.endDate)).day ?? 0) + 1
                        MiniStatCard(value: "\(totalDays)", label: "Days planned")
                    }
                    
                    // 4. ITINERARY PREVIEW
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Upcoming Activities")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                            Spacer()
                            NavigationLink(destination: ItineraryView(tripViewModel: tripViewModel, activityViewModel: activityViewModel, trip: trip)) {
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
                            let previewActivities = activityViewModel.activities
                                .filter { $0.tripId == trip.id }
                                .sorted { $0.startTime < $1.startTime }
                                .prefix(3)
                            
                            if previewActivities.isEmpty {
                                Text("No activities planned yet.")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 8)
                            } else {
                                ForEach(previewActivities) { activity in
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
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(18)
                    
                    // 5. NEEDS ATTENTION (Progress Bar Dinamis)
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Needs Attention")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                        
                        VStack(spacing: 12) {
                            ForEach(trip.memberIds, id: \.self) { memberId in
                                let initials = String(memberId.prefix(2)).uppercased()
                                let displayName = memberId == tripViewModel.currentUserID ? "You" : "User \(initials)"
                                
                                // Kalkulasi progress per orang (sementara pakai progress global trip)
                                let userProgress = totalItemsCount > 0 ? Double(packedItemsCount) / Double(totalItemsCount) : 0.0
                                let currentStatus = userProgress == 1.0 ? "DONE" : (userProgress > 0 ? "IN PROGRESS" : "NOT STARTED")
                                let currentColor = userProgress == 1.0 ? Color.green : (userProgress > 0 ? Color.orange : Color.gray)
                                
                                AttentionRowComponent(
                                    initials: initials.isEmpty ? "?" : initials,
                                    name: displayName,
                                    progress: userProgress,
                                    status: currentStatus,
                                    statusColor: currentColor
                                )
                                
                                if memberId != trip.memberIds.last {
                                    Divider().background(Color.gray.opacity(0.1))
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(18)
                    .padding(.bottom, 25)
                    
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: sizeClass == .compact ? .infinity : 700)
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}

// MARK: - Komponen Bantuan
struct MiniStatCard: View {
    var value: String; var label: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .black))
                .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct AttentionRowComponent: View {
    var initials: String; var name: String; var progress: Double; var status: String; var statusColor: Color
    var body: some View {
        HStack(spacing: 12) {
            Circle().fill(Color(red: 0.08, green: 0.15, blue: 0.25).opacity(0.8)).frame(width: 36, height: 36).overlay(Text(initials).font(.system(size: 12, weight: .bold)).foregroundColor(.white))
            Text(name).font(.system(size: 14, weight: .bold)).foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25)).frame(width: 60, alignment: .leading).lineLimit(1)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gray.opacity(0.15))
                    Capsule().fill(statusColor).frame(width: geo.size.width * CGFloat(progress))
                }
            }.frame(height: 6).padding(.horizontal, 4)
            Text("\(Int(progress * 100))%").font(.system(size: 12, weight: .bold)).foregroundColor(.gray).frame(width: 35, alignment: .trailing)
            Text(status).font(.system(size: 9, weight: .black)).foregroundColor(statusColor).padding(.horizontal, 8).padding(.vertical, 5).background(statusColor.opacity(0.1)).cornerRadius(6).lineLimit(1)
        }
    }
}

#Preview {
    let sampleTrip = Trip(
        id: "PREVIEW_ID",
        name: "Preview Bali",
        destination: "Bali",
        startDate: Date(),
        endDate: Date().addingTimeInterval(86400 * 3),
        ownerId: "me",
        memberIds: ["me"],
        groupProgress: 0.68
    )
    
    return TripDetailOverviewView(
        trip: sampleTrip,
        tripViewModel: TripViewModel(),
        activityViewModel: ActivityViewModel(),
        // 📢 Masukin PackingViewModel dan oper sampleTrip ke dalamnya
        packingViewModel: PackingViewModel(trip: sampleTrip)
    )
}
