//
//  TripViewModelTest.swift
//  ALP_MAD_WEPACKTests
//
//  Created by Angelique Kyra on 06/06/26.
//

import XCTest
@testable import ALP_MAD_WEPACK

@MainActor
final class TripViewModelTests: XCTestCase {
    var viewModel: TripViewModel!

    override func setUp() {
        super.setUp()
        viewModel = TripViewModel()
    }

    func testCalculateDaysAway_ReturnsCorrectNumber() {
        let fiveDaysFromNow = Date().addingTimeInterval(86400 * 5)
        let daysAway = viewModel.calculateDaysAway(from: fiveDaysFromNow)
        XCTAssertEqual(daysAway, 5)
    }

    func testAddTrip_IncreasesTripCount() {
        let newTrip = Trip(id: "1", name: "Bali", destination: "Bali", startDate: Date(), endDate: Date(), ownerId: "me", memberIds: [], groupProgress: 0, customImage: nil)
        viewModel.createNewTrip(
            name: "Liburan Bali",
            destination: "Bali",
            start: Date(),
            end: Date().addingTimeInterval(86400 * 3),
            imageData: nil
        )
        XCTAssertEqual(viewModel.trips.count, 1)
    }
}
