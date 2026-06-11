//
//  AddMemberViewModelTest.swift
//  ALP_MAD_WEPACK
//
//  Created by Angelique Kyra on 12/06/26.
//

import XCTest
@testable import ALP_MAD_WEPACK // Sesuaikan dengan nama project kamu

final class AddMemberViewModelTests: XCTestCase {
    
    var viewModel: AddMemberViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AddMemberViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // Test Load Trip Data
    func testLoadTripData() {
        viewModel.loadTripData(id: "trip123", name: "Bali Vacation", dateString: "12 Dec 2026")
        
        XCTAssertEqual(viewModel.tripId, "trip123")
        XCTAssertEqual(viewModel.tripName, "Bali Vacation")
        XCTAssertEqual(viewModel.tripDate, "12 Dec 2026")
    }
    
    // Test Load Current User & Generate Initials
    func testLoadCurrentUser() {
        viewModel.loadCurrentUser(id: "user1", name: "Angelique Kyra", username: "@angelique")
        
        XCTAssertEqual(viewModel.members.count, 1)
        XCTAssertEqual(viewModel.members.first?.id, "user1")
        XCTAssertEqual(viewModel.members.first?.initials, "AN") // 2 huruf pertama Kapital
        XCTAssertTrue(viewModel.members.first?.isYou == true)
        
        // Cek agar tidak ada duplikasi jika dipanggil 2x dengan ID yang sama
        viewModel.loadCurrentUser(id: "user1", name: "Angelique Kyra", username: "@angelique")
        XCTAssertEqual(viewModel.members.count, 1, "Member tidak boleh duplikat")
    }
    
    // Test Remove Member
    func testRemoveMember() {
        viewModel.loadCurrentUser(id: "user1", name: "Angelique", username: "@angel")
        XCTAssertEqual(viewModel.members.count, 1)
        
        viewModel.removeMember(id: "user1")
        XCTAssertTrue(viewModel.members.isEmpty, "Member seharusnya kosong setelah dihapus")
    }
    
    // Test Reset Form
    func testResetForm() {
        viewModel.inviteInput = "test@email.com"
        viewModel.resetForm()
        
        XCTAssertTrue(viewModel.inviteInput.isEmpty, "Form input harusnya kosong setelah reset")
    }
}
