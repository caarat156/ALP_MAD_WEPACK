//
//  TripViewModelTest.swift
//  ALP_MAD_WEPACK_Watch Watch AppUITests
//
//  Created by Angelique Kyra on 04/06/26.
//

import XCTest
@testable import ALP_MAD_WEPACK

// Pakai @MainActor karena ViewModel kamu kemungkinan mengubah UI (mirip tugas LabWeek12)[cite: 1, 6]
@MainActor
final class TripViewModelTests: XCTestCase {
    
    // Variabel yang mau di-test
    var viewModel: TripViewModel!

    // setUp() akan dijalanin Xcode SEBELUM tiap fungsi test dimulai[cite: 2, 6]
    override func setUp() {
        super.setUp()
        // Kita bikin instance ViewModel baru yang masih fresh[cite: 6]
        viewModel = TripViewModel()
        // Kosongkan data dummy biar ngetesnya gampang
        viewModel.trips = []
        viewModel.activities = []
    }

    // tearDown() dijalanin SETELAH test selesai buat bersih-bersih
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // ==========================================
    // 1. TEST LOGIKA HARI (Trip Overview)
    // ==========================================
    func testCalculateDaysAway_ReturnsCorrectNumber() {
        // Anggap tanggal mulai trip adalah 5 hari dari hari ini
        let fiveDaysFromNow = Date().addingTimeInterval(86400 * 5)
        
        // Panggil fungsi yang ada di ViewModel kamu
        let daysAway = viewModel.calculateDaysAway(from: fiveDaysFromNow)
        
        // Kita cek, apakah hasilnya beneran 5? (Mirip testCalculateTotal di tugasmu)[cite: 2]
        XCTAssertEqual(daysAway, 5, "Fungsi calculateDaysAway harusnya mengembalikan angka 5")
    }

    // ==========================================
    // 2. TEST LOGIKA NAMBAH TRIP (Trip List)
    // ==========================================
    func testAddTrip_IncreasesTripCount() {
        // Cek jumlah awal, harusnya 0
        XCTAssertEqual(viewModel.trips.count, 0)
        
        // Bikin trip palsu
        let newTrip = Trip(
            id: "trip123",
            name: "Liburan ke Bali",
            destination: "Bali",
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 3),
            ownerId: "user1",
            memberIds: ["user1"],
            groupProgress: 0.0,
            customImage: nil
        )
        
        // Masukkan ke array (atau panggil fungsi addTrip() kalau kamu punya)
        viewModel.trips.append(newTrip)
        
        // Cek, apakah jumlahnya sekarang jadi 1? (Mirip testAddToCart_QuantityIncreased)[cite: 6]
        XCTAssertEqual(viewModel.trips.count, 1)
        XCTAssertEqual(viewModel.trips.first?.name, "Liburan ke Bali")
    }

    // ==========================================
    // 3. TEST LOGIKA FILTER ITINERARY (Itinerary)
    // ==========================================
    func testFilterActivities_OnlyShowsActivitiesForSelectedTrip() {
        // Bikin 2 aktivitas untuk Trip A, dan 1 aktivitas untuk Trip B
        let activity1 = ItineraryActivity(id: "act1", tripId: "tripA", name: "Makan Siang", location: "Cafe", type: .food, startTime: Date(), endTime: nil)
        let activity2 = ItineraryActivity(id: "act2", tripId: "tripA", name: "Pantai", location: "Kuta", type: .leisure, startTime: Date(), endTime: nil)
        let activity3 = ItineraryActivity(id: "act3", tripId: "tripB", name: "Tidur", location: "Hotel", type: .lodging, startTime: Date(), endTime: nil)
        
        viewModel.activities = [activity1, activity2, activity3]
        
        // Simulasikan logika filter yang ada di file ItineraryView kamu
        let targetTripId = "tripA"
        let filteredActivities = viewModel.activities.filter { $0.tripId == targetTripId }
        
        // Harusnya cuma ada 2 aktivitas yang lolos filter (Makan Siang & Pantai)
        XCTAssertEqual(filteredActivities.count, 2, "Harusnya cuma 2 aktivitas dari tripA yang muncul")
        
        // Harusnya aktivitas dari tripB (Tidur) gak ikutan masuk
        let hasSleepActivity = filteredActivities.contains { $0.name == "Tidur" }
        XCTAssertFalse(hasSleepActivity, "Aktivitas dari Trip B tidak boleh bocor ke Trip A")
    }
}
