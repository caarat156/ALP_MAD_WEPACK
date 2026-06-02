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
                
                VStack(spacing: 0) {
                    
                    // --- HEADER SECTION (DI LUAR SCROLLVIEW AGAR AMAN) ---
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
                        
                        // 📢 Tombol New Trip menggunakan Button bawaan SwiftUI agar areanya presisi & tidak bentrok
                        Button(action: {
                            isShowingAddTrip = true // Mengunci pemicu modal AddTrip
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
                        // Mencegah modifier tombol menyebar kemana-mana
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    .background(Color.white) // Memberi efek header atas solid rapi
                    
                    // --- AREA SCROLL KHUSUS UNTUK CARD SAJA ---
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(viewModel.trips) { trip in
                                // Klik Card Trip -> Navigasi masuk ke TripDetailOverviewView
                                    .navigationDestination(for: Trip.self) { selectedTrip in
                                                    // 📢 5. GANTI MENGARAH KE MAIN TRIP VIEW
                                                    MainTripView(trip: selectedTrip, viewModel: viewModel)
                                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.top, 15)
                    }
                }
            }
            // 📢 JALUR MODAL NYA DI SINI
            .sheet(isPresented: $isShowingAddTrip) {
                AddTripModalView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    TripListView()
}
