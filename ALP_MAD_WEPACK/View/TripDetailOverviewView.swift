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
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.97, blue: 0.98).ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Card Banner Atas
                    VStack(alignment: .leading, spacing: 6) {
                        Text("ACTIVE GROUP TRIP")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.cyan)
                        Text(trip.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Text("\(trip.destination) • \(trip.dateRangeString)")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 0.08, green: 0.15, blue: 0.25))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // --- TIMELINE ACTIVITY SECTION ---
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Day 1 Itinerary Preview")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                        
                        // Menyaring list aktivitas yang hanya punya TripID milik kartu ini saja!
                        let filteredActivities = viewModel.activities.filter { $0.tripId == trip.id }
                        
                        if filteredActivities.isEmpty {
                            ContentUnavailableView("No Activities Yet", systemImage: "calendar.badge.plus", description: Text("Go to Itinerary tab to build your timeline."))
                                .frame(height: 150)
                        } else {
                            VStack(alignment: .leading, spacing: 18) {
                                ForEach(filteredActivities) { activity in
                                    HStack(alignment: .top, spacing: 14) {
                                        // Waktu
                                        Text(activity.timeString)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                                            .frame(width: 45, alignment: .leading)
                                        
                                        // Indikator Titil Timeline Jalur Kereta
                                        VStack(spacing: 4) {
                                            Circle()
                                                .fill(activity.type == .transport ? Color.blue : (activity.type == .food ? Color.orange : Color.teal))
                                                .frame(width: 10, height: 10)
                                                .padding(.top, 4)
                                        }
                                        
                                        // Deskripsi Tempat
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(activity.name)
                                                .font(.system(size: 14, weight: .semibold))
                                            Text(activity.location)
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        
                                        // Icon Kategori Berdasarkan Model Enum kamu
                                        Image(systemName: activity.type.iconName)
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                            .padding(6)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(6)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Overview")
        .navigationBarTitleDisplayMode(.inline)
    }
}
