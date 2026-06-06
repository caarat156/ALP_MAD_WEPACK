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

    func testAddActivity_SortsByTime() {
        let activity1 = ItineraryActivity(id: "1", tripId: "T1", name: "Siang", startTime: Date().addingTimeInterval(3600), endTime: nil, location: "Loc", type: .food)
        let activity2 = ItineraryActivity(id: "2", tripId: "T1", name: "Pagi", startTime: Date(), endTime: nil, location: "Loc", type: .food)
        
        viewModel.addActivity(activity1)
        viewModel.addActivity(activity2)
        
        // Cek apakah aktivitas pertama adalah "Pagi" (karena lebih awal)
        XCTAssertEqual(viewModel.activities.first?.name, "Pagi")
    }
}
