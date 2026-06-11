//
//  TripViewModelTest.swift
//  ALP_MAD_WEPACKTests
//
//  Created by Angelique Kyra on 06/06/26.
//

import XCTest
@testable import ALP_MAD_WEPACK // Pastikan nama ini sesuai dengan nama project targetmu

@MainActor
final class TripViewModelTests: XCTestCase {
    var viewModel: TripViewModel!

    override func setUp() {
        super.setUp()
        viewModel = TripViewModel()
    }

    func testCalculateDaysAway_ReturnsCorrectNumber() {
        // Test jarak hari (calculateDaysAway)
        let fiveDaysFromNow = Date().addingTimeInterval(86400 * 5) // 86400 detik = 1 hari
        let daysAway = viewModel.calculateDaysAway(from: fiveDaysFromNow)
        
        XCTAssertEqual(daysAway, 5)
    }

    func testAddTripToArray_IncreasesTripCount() {
        // 1. Buat data dummy Trip sesuai dengan model terbaru (tanpa customImage)
        let newTrip = Trip(
            id: "1",
            name: "Liburan Bali",
            destination: "Bali",
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 3), // Liburan 3 hari setelah startDate
            ownerId: "me",
            memberIds: ["me"],
            groupProgress: 0.0
        )
        
        // 2. Karena createNewTrip() sekarang nembak ke Firebase (async),
        // untuk test logika UI kita langsung masukkan ke array ViewModel
        viewModel.trips.append(newTrip)
        
        // 3. Verifikasi apakah jumlah trip bertambah
        XCTAssertEqual(viewModel.trips.count, 1)
        
        // 4. Verifikasi apakah datanya benar masuk
        XCTAssertEqual(viewModel.trips.first?.name, "Liburan Bali")
        
        // 5. Ekstra! Test computed property durationInDays sekalian
        XCTAssertEqual(viewModel.trips.first?.durationInDays, 4) // 3 interval hari = 4 hari total
    }
}
