//
//  TripViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//
//
//   TripViewModel.swift
//   ALP_MAD_WEPACK
//
//   Created by MacintoshHD on 29/05/26.
//

import SwiftUI
import Observation

@Observable
class TripViewModel {
    // Mengambil data awal langsung dari MockData yang kamu punya
    var trips: [Trip] = MockData.sampleTrips
    var activities: [ItineraryActivity] = MockData.sampleActivities
    
    // 🔑 ID USER YANG SEDANG LOGIN (Dinamis)
    // Nilai default ini akan otomatis berubah saat sistem login kamu berhasil mengubah nilai ini
    var currentUserID: String = "USER_ACTIVE"
    
    // Fungsi untuk menghitung sisa hari secara otomatis berdasarkan tanggal saat ini
    func calculateDaysAway(from startDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTrip = calendar.startOfDay(for: startDate)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTrip)
        return max(0, components.day ?? 0)
    }
    
    // 📢 SOLUSI DUPLIKASI: Hanya ada SATU fungsi formal untuk membuat Trip Baru
    // Fungsi ini menangani teks input, validasi kosong, gambar kustom, DAN User ID Login dinamis!
    func createNewTrip(name: String, destination: String, start: Date, end: Date, imageData: Data? = nil) {
        // Validasi input agar tidak memasukkan data kosong
        guard !name.isEmpty && !destination.isEmpty else { return }
        
        let newTrip = Trip(
            id: "TRIP_\(UUID().uuidString.prefix(6))", // Membuat ID unik acak
            name: name,
            destination: destination,
            startDate: start,
            endDate: end,
            ownerId: currentUserID,      // 🔑 Menggunakan ID user yang sedang login secara dinamis!
            memberIds: [currentUserID],  // Otomatis pembuat langsung masuk jadi member pertama
            groupProgress: 0.0,          // Trip baru dimulai dari progress 0%
            customImage: imageData       // Menyimpan data gambar kustom dari galeri jika ada
        )
        
        // Memasukkan trip baru ke urutan paling atas list agar langsung kelihatan oleh user
        trips.insert(newTrip, at: 0)
    }
    
    // 🔥 Fungsi untuk menambahkan Aktivitas Baru ke Itinerary
    func addActivity(_ activity: ItineraryActivity) {
        activities.append(activity)
        
        // Urutkan aktivitas secara otomatis dari jam paling pagi ke malam
        activities.sort { $0.startTime < $1.startTime }
    }
}
