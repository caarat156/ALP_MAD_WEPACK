//
//  TripListView.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import SwiftUI

struct TripListView: View {
    @State private var viewModel = TripViewModel()
    @State private var isShowingAddTrip = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background abu-abu terang soft sesuai Figma
                Color(red: 0.96, green: 0.97, blue: 0.98)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // --- HEADER SECTION ---
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("My Trips")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                                Text("\(viewModel.trips.count) trips total")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            
                            // Tombol Tambah Trip Baru
                            Button(action: { isShowingAddTrip.toggle() }) {
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
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // --- LOOPING CARD TRIP ---
                        ForEach(viewModel.trips) { trip in
                            NavigationLink(destination: TripDetailOverviewView(trip: trip, viewModel: viewModel)) {
                                TripCardComponent(trip: trip, viewModel: viewModel)
                            }
                            .buttonStyle(PlainButtonStyle()) // Menjaga warna card asli figma
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingAddTrip) {
                AddTripModalView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    TripListView()
}
