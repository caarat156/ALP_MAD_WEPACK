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

    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.97, blue: 0.98).ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // BANNER STATIS
                    ZStack(alignment: .bottomLeading) {
                        Image("bali_cover")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .clipped()
                    }
                    .cornerRadius(20)
                    .padding(.horizontal)

                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Group Readiness").font(.headline)
                                Text("\(trip.memberIds.count) members • synced live")
                                    .font(.caption).foregroundColor(.gray)
                            }
                            Spacer()
                            Text("\(Int(trip.groupProgress * 100))%").font(.title.bold())
                        }
                        
                        HStack {
                            Text("Members loaded from Firebase")
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(18)
                    .padding(.horizontal)
                    
                    // STATISTIK BARANG
                    HStack(spacing: 12) {
                        MiniStatCard(value: "12", label: "Items packed")
                        MiniStatCard(value: "10", label: "Remaining")
                        MiniStatCard(value: "4", label: "Days planned")
                    }
                    .padding(.horizontal)
                    
                    // DAY 2 PREVIEW
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
                            let day2Activities = activityViewModel.activities.filter { $0.tripId == trip.id }
                            
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
                    
                    // NEEDS ATTENTION
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
                .frame(maxWidth: sizeClass == .compact ? .infinity : 700)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}

// Struct MiniStatCard & AttentionRowComponent biarkan sama seperti kodemu sebelumnya...
struct MiniStatCard: View {
    var value: String; var label: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value).font(.system(size: 24, weight: .black)).foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
            Text(label).font(.system(size: 11, weight: .medium)).foregroundColor(.gray)
        }.padding(.vertical, 14).padding(.horizontal, 16).frame(maxWidth: .infinity, alignment: .leading).background(Color.white).cornerRadius(16)
    }
}

struct AttentionRowComponent: View {
    var initials: String; var name: String; var progress: Double; var status: String; var statusColor: Color
    var body: some View {
        HStack(spacing: 12) {
            Circle().fill(Color(red: 0.08, green: 0.15, blue: 0.25).opacity(0.8)).frame(width: 36, height: 36).overlay(Text(initials).font(.system(size: 12, weight: .bold)).foregroundColor(.white))
            Text(name).font(.system(size: 14, weight: .bold)).foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25)).frame(width: 60, alignment: .leading)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gray.opacity(0.15))
                    Capsule().fill(statusColor).frame(width: geo.size.width * CGFloat(progress))
                }
            }.frame(height: 6).padding(.horizontal, 4)
            Text("\(Int(progress * 100))%").font(.system(size: 12, weight: .bold)).foregroundColor(.gray).frame(width: 35, alignment: .trailing)
            Text(status).font(.system(size: 9, weight: .black)).foregroundColor(statusColor).padding(.horizontal, 8).padding(.vertical, 5).background(statusColor.opacity(0.1)).cornerRadius(6)
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
        activityViewModel: ActivityViewModel()
    )
}
