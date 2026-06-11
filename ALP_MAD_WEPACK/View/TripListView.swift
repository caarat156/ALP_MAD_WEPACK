//
//  TripListView.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import SwiftUI

struct TripListView: View {
    @State private var tripViewModel = TripViewModel()
    @State private var activityViewModel = ActivityViewModel()
    @State private var isShowingAddTrip = false
  
    let columns = [
        GridItem(.adaptive(minimum: 300), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {

                Color(red: 0.96, green: 0.97, blue: 0.98)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("My Trips")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                            
                            Text("\(tripViewModel.trips.count) trips total")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        Button(action: {
                            isShowingAddTrip = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "plus")
                                Text("New Trip")
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color(red: 0.08, green: 0.15, blue: 0.25))
                            .cornerRadius(20)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    .background(Color.white)
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(tripViewModel.trips) { trip in
                                
                                NavigationLink(value: trip) {
                                    TripCardComponent(trip: trip, tripViewModel: tripViewModel, activityViewModel: activityViewModel)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                            }
                        }
                        .padding(.top, 15)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationDestination(for: Trip.self) { selectedTrip in
                MainTripView(trip: selectedTrip, tripViewModel: tripViewModel)
            }
            .sheet(isPresented: $isShowingAddTrip) {
                AddTripModalView(tripviewModel: tripViewModel)
            }
            .onAppear {
                // Re-fetch ketika view muncul agar memakai UID asli yang sudah siap dari Auth
                tripViewModel.fetchTrips()
            }
        }
    }
}

#Preview {
    TripListView()
}
