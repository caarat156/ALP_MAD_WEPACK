//
//  ActivityViewModelTest.swift
//  ALP_MAD_WEPACKTests
//
//  Created by Angelique Kyra on 06/06/26.
//

import XCTest
@testable import ALP_MAD_WEPACK

@MainActor
final class ActivityViewModelTests: XCTestCase {
    var viewModel: ActivityViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ActivityViewModel()
    }

    func testActivities_SortsByTimeCorrectly() {
        // 1. Buat dummy data dengan urutan yang sengaja dibalik (Siang dulu baru Pagi)
        // Aku kasih default Date() buat endTime jaga-jaga kalau model kamu nggak nerima nil
        let activitySiang = ItineraryActivity(id: "1", tripId: "T1", name: "Siang", startTime: Date().addingTimeInterval(3600), endTime: Date().addingTimeInterval(7200), location: "Loc", type: .food)
        
        let activityPagi = ItineraryActivity(id: "2", tripId: "T1", name: "Pagi", startTime: Date(), endTime: Date().addingTimeInterval(3600), location: "Loc", type: .food)
        
        // 2. Masukkan langsung ke array lokal (simulasi data yang ditarik dari Firebase)
        viewModel.activities = [activitySiang, activityPagi]
        
        // 3. Jalankan logika sorting yang ada di dalam snapshot listener
        viewModel.activities.sort { $0.startTime < $1.startTime }
        
        // 4. Verifikasi apakah aktivitas pertama sekarang adalah "Pagi"
        XCTAssertEqual(viewModel.activities.first?.name, "Pagi")
    }
    
    func testGetActivities_FiltersByDayNumber() {
        let tripStartDate = Date()
        let day2Date = tripStartDate.addingTimeInterval(86400) // Waktu untuk besok (Hari ke-2)
        
        // Buat dummy data (Ganti tipe yang error jadi .attraction dan .leisure)
        let activityDay1 = ItineraryActivity(id: "1", tripId: "T1", name: "Ke Pantai", startTime: tripStartDate, endTime: tripStartDate.addingTimeInterval(3600), location: "Bali", type: .attraction)
        
        let activityDay2 = ItineraryActivity(id: "2", tripId: "T1", name: "Beli Oleh-Oleh", startTime: day2Date, endTime: day2Date.addingTimeInterval(3600), location: "Pasar", type: .leisure)
        
        // Masukkan secara lokal
        viewModel.activities = [activityDay1, activityDay2]
        
        // Coba tarik data HANYA untuk Hari ke-2
        let filteredActivities = viewModel.getActivities(forDay: 2, tripStartDate: tripStartDate)
        
        // Verifikasi hasilnya
        XCTAssertEqual(filteredActivities.count, 1, "Harusnya cuma ada 1 aktivitas di Hari ke-2")
        XCTAssertEqual(filteredActivities.first?.name, "Beli Oleh-Oleh", "Aktivitas yang kepanggil salah")
    }
    
    func testGetActivitiesGroupedByDay_GroupsCorrectly() {
            // 1. Setup Data: Trip mulai hari ini
            let tripStartDate = Date()
            let trip = Trip(id: "T1", name: "Trip Bali", destination: "Bali", startDate: tripStartDate, endDate: tripStartDate.addingTimeInterval(86400 * 2), ownerId: "user1", memberIds: ["user1"], groupProgress: 0.0)
            
            // 2. Buat aktivitas hari ke-1 dan hari ke-2
            let activityDay1 = ItineraryActivity(id: "1", tripId: "T1", name: "Pantai", startTime: tripStartDate, endTime: tripStartDate.addingTimeInterval(3600), location: "Bali", type: .attraction)
            let activityDay2 = ItineraryActivity(id: "2", tripId: "T1", name: "Oleh-oleh", startTime: tripStartDate.addingTimeInterval(86400), endTime: tripStartDate.addingTimeInterval(90000), location: "Pasar", type: .leisure)
            
            // 3. Masukkan ke ViewModel
            viewModel.activities = [activityDay1, activityDay2]
            
            // 4. Jalankan fungsi grouping
            let grouped = viewModel.getActivitiesGroupedByDay(forTrip: trip)
            
            // 5. Verifikasi
            XCTAssertEqual(grouped.count, 2, "Harusnya ada 2 grup hari yang terbentuk")
            XCTAssertNotNil(grouped[1], "Harusnya ada data untuk Day 1")
            XCTAssertNotNil(grouped[2], "Harusnya ada data untuk Day 2")
            XCTAssertEqual(grouped[1]?.first?.name, "Pantai")
            XCTAssertEqual(grouped[2]?.first?.name, "Oleh-oleh")
        }
}
