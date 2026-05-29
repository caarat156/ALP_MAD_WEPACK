//
//  TripViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import SwiftUI
import Observation

@Observable
class TripViewModel {
    // Mengambil data awal langsung dari MockData yang kamu punya
    var trips: [Trip] = MockData.sampleTrips
    var activities: [ItineraryActivity] = MockData.sampleActivities
    
    // Fungsi untuk menghitung sisa hari secara otomatis berdasarkan tanggal saat ini
    func calculateDaysAway(from startDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTrip = calendar.startOfDay(for: startDate)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTrip)
        return max(0, components.day ?? 0)
    }
    
    // LOGIKA: Fungsi formal untuk menambahkan Trip baru dari Form ke dalam list
    func createNewTrip(name: String, destination: String, start: Date, end: Date) {
        guard !name.isEmpty && !destination.isEmpty else { return }
        
        let newTrip = Trip(
            id: "TRIP_\(UUID().uuidString.prefix(6))", // Membuat ID acak formal
            name: name,
            destination: destination,
            startDate: start,
            endDate: end,
            ownerId: "USER_CACA_123", // Default user aktif
            memberIds: ["USER_CACA_123"],
            groupProgress: 0.0 // Trip baru dimulai dari 0%
        )
        
        // Memasukkan trip baru ke urutan paling atas list
        trips.insert(newTrip, at: 0)
    }
}
