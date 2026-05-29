//
//  MainTripView.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct MainTripView: View {
    // Tambahkan variabel ini di dalam struct MainTripView (di atas var body: some View)
    let trip = MockData.sampleTrips[0]

    // Fungsi helper untuk memformat tanggal (taruh juga di dalam struct MainTripView)
    func formatTripDate(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let startStr = formatter.string(from: start)
        formatter.dateFormat = "d, yyyy"
        let endStr = formatter.string(from: end)
        return "\(startStr)–\(endStr)"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // ==========================================
            // SHARED HEADER (Tetap ada di setiap Tab)
            // ==========================================
            HStack {
                Button(action: {
                    // Aksi tombol back
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .padding(.trailing, 8)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    // Mengambil nama trip dari MockData
                    Text(trip.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    // Mengambil destinasi dan tanggal dari MockData
                    Text("\(trip.destination) • \(formatTripDate(start: trip.startDate, end: trip.endDate))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            
            Divider()
            
            // ==========================================
            // SHARED BOTTOM NAVBAR (TAB VIEW)
            // ==========================================
            TabView {
                // Tab 1: Overview
                Text("Halaman Overview")
                    .tabItem {
                        Image(systemName: "square.grid.2x2")
                        Text("Overview")
                    }
                
                // Tab 2: Packing (Tugas Temanmu)
                Text("Halaman Packing")
                    .tabItem {
                        Image(systemName: "shippingbox")
                        Text("Packing")
                    }
                
                // Tab 3: Itinerary (Tugas Temanmu)
                Text("Halaman Itinerary")
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Itinerary")
                    }
                
                // Tab 4: Members (Tugas Kamu)
                // Memanggil View Member yang ada di file terpisah
                MemberPageView()
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("Members")
                    }
                
                // Tab 5: Account (Budget Dihapus)
                Text("Halaman Account")
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Account")
                    }
            }
            .accentColor(Color(red: 37/255, green: 45/255, blue: 67/255)) // Warna biru gelap saat tab aktif
        }
        .navigationBarHidden(true) // Menyembunyikan navbar bawaan Apple
    }
}
