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
    
    // 📢 1. VARIABEL UNTUK RESPONSIVE IPAD (Grid adaptif)
    let columns = [
        GridItem(.adaptive(minimum: 300), spacing: 20)
    ]
    
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
                        
                        // Tombol New Trip
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
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    .background(Color.white) // Memberi efek header atas solid rapi
                    
                    
                    // --- AREA SCROLL KHUSUS UNTUK CARD SAJA ---
                    ScrollView {
                        // 📢 2. MENGGUNAKAN LAZYVGRID AGAR IPAD BISA 2/3 KOLOM
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.trips) { trip in
                                
                                // 📢 3. NAVIGATION LINK (Sebagai "Trigger/Pemicu")
                                NavigationLink(value: trip) {
                                    TripCardComponent(trip: trip, viewModel: viewModel)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                            }
                        }
                        .padding(.top, 15)
                        .padding(.horizontal) // Tambahan padding agar rapi di layar lebar
                    }
                }
            }
            // 📢 4. NAVIGATION DESTINATION TARUH DI SINI (Di luar elemen UI)
            // Ini akan menangkap `value: trip` dari NavigationLink di atas
            .navigationDestination(for: Trip.self) { selectedTrip in
                MainTripView(trip: selectedTrip, viewModel: viewModel)
            }
            // 📢 JALUR MODAL NEW TRIP
            .sheet(isPresented: $isShowingAddTrip) {
                AddTripModalView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    TripListView()
}
