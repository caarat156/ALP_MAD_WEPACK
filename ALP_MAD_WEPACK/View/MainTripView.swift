//
//  MainTripView.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct MainTripView: View {
    let trip: Trip
    var tripViewModel: TripViewModel
    
    @State private var activityViewModel = ActivityViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var accountViewModel = AccountViewModel()
    
    // 📢 Otak Utama Packing
    @StateObject private var packingViewModel: PackingViewModel
    
    init(trip: Trip, tripViewModel: TripViewModel) {
        self.trip = trip
        self.tripViewModel = tripViewModel
        self._packingViewModel = StateObject(wrappedValue: PackingViewModel(trip: trip))
    }
    
    func formatTripDate(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let startStr = formatter.string(from: start)
        formatter.dateFormat = "MMM d, yyyy"
        let endStr = formatter.string(from: end)
        return "\(startStr) – \(endStr)"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // --- HEADER ATAS ---
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                        .padding(.trailing, 8)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(trip.destination.lowercased().contains("bali") ? "🌴" : "✈️")
                        Text(trip.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                    }
                    Text("\(trip.destination) • \(formatTripDate(start: trip.startDate, end: trip.endDate))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                HStack(spacing: 12) {
                    NavigationLink(destination: AccountView(authViewModel: authViewModel)) {
                        Circle()
                            .fill(Color(red: 0.08, green: 0.15, blue: 0.25))
                            .frame(width: 30, height: 30)
                        // Di MainTripView.swift

                        .overlay(
                            // 📢 Kalau avatarInitials kosong, kasih inisial default seperti "?"
                            Text(!accountViewModel.avatarInitials.isEmpty ? accountViewModel.avatarInitials : "?")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        )                    }
                }
            }
            .padding()
            .background(Color.white)
            
            Divider()
            
            // --- NAVBAR ---
            TabView {
                TripDetailOverviewView(
                    trip: trip,
                    tripViewModel: tripViewModel,
                    activityViewModel: activityViewModel,
                    packingViewModel: packingViewModel
                )
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Overview")
                }
                
                PackingListView(viewModel: packingViewModel)
                    .tabItem {
                        Image(systemName: "shippingbox")
                        Text("Packing")
                    }
                
                ItineraryView(tripViewModel: tripViewModel, activityViewModel: activityViewModel, trip: trip)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Itinerary")
                    }
                
                // 📢 PERBAIKAN: Hanya oper packingViewModel saja
                MemberPageView(
                                    packingViewModel: packingViewModel,
                                    tripViewModel: tripViewModel
                                )
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("Members")
                    }
            }
            .accentColor(Color(red: 37/255, green: 45/255, blue: 67/255))
        }
        .navigationBarHidden(true)
    }
}
