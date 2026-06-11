//
//  PackingTest.swift
//  ALP_MAD_WEPACKTests
//
//  Created by Anastasia on 04/06/26.
//

import XCTest
@testable import ALP_MAD_WEPACK

final class PackingTest: XCTestCase {
    
    var viewModel: PackingViewModel!
    
    override func setUp() {
        super.setUp()
        let dummyTrip = Trip(id: "T1", name: "Test Trip", destination: "Bali", startDate: Date(), endDate: Date(), ownerId: "U1", memberIds: ["U1"], groupProgress: 0.0)
        viewModel = PackingViewModel(trip: dummyTrip)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testPackingItem_Initialization_ShouldBeCorrect() {
        let expectedId = "ITEM_123"
        let expectedName = "Sunblock"
        let expectedCategory: PackingCategory = .essentials
        
        let item = PackingItem(
            id: expectedId,
            tripId: "TRIP_BALI",
            name: expectedName,
            category: expectedCategory,
            isPacked: false,
            assignedTo: ["USER_CACA_123"]
        )
        
        XCTAssertEqual(item.id, expectedId, "ID item tidak cocok")
        XCTAssertEqual(item.name, expectedName, "Nama item tidak cocok")
        XCTAssertEqual(item.category, expectedCategory, "Kategori item salah")
        XCTAssertFalse(item.isPacked, "Item baru harusnya belum di-packing (false)")
    }
    
    func testPackingItem_ToggleIsPacked_ShouldChangeStatus() {
        var item = PackingItem(
            id: "ITEM_1",
            tripId: "TRIP_1",
            name: "Kacamata Renang",
            category: .essentials,
            isPacked: false,
            assignedTo: ["Everyone"]
        )
        
        item.isPacked.toggle()
        
        XCTAssertTrue(item.isPacked, "Status isPacked harusnya berubah menjadi true setelah di-toggle")
        
        item.isPacked.toggle()
        
        XCTAssertFalse(item.isPacked, "Status isPacked harusnya kembali menjadi false")
    }
    
    func testPackingLogic_FilterItemsForSpecificUser() {
        let userId = "USER_CACA"
        let allItems = [
            PackingItem(id: "1", tripId: "T1", name: "Baju", category: .clothing, isPacked: false, assignedTo: ["USER_CACA"]),
            PackingItem(id: "2", tripId: "T1", name: "P3K", category: .essentials, isPacked: false, assignedTo: ["Everyone"]),
            PackingItem(id: "3", tripId: "T1", name: "Kamera", category: .electronics, isPacked: false, assignedTo: ["USER_BUDI"])
        ]
        
        let filteredItems = allItems.filter { item in
            item.assignedTo.contains("Everyone") || item.assignedTo.contains(userId)
        }
        
        XCTAssertEqual(filteredItems.count, 2, "Seharusnya Caca hanya melihat 2 barang (miliknya dan Everyone)")
        XCTAssertTrue(filteredItems.contains(where: { $0.name == "Baju" }), "Barang Caca harusnya ada")
        XCTAssertTrue(filteredItems.contains(where: { $0.name == "P3K" }), "Barang Everyone harusnya ada")
        XCTAssertFalse(filteredItems.contains(where: { $0.name == "Kamera" }), "Barang Budi tidak boleh muncul untuk Caca")
    }
    
    func testPackingLogic_CalculateProgress_ShouldReturnCorrectPercentage() {
        let items = [
            PackingItem(id: "1", tripId: "T1", name: "A", category: .essentials, isPacked: true, assignedTo: []),
            PackingItem(id: "2", tripId: "T1", name: "B", category: .essentials, isPacked: true, assignedTo: []),
            PackingItem(id: "3", tripId: "T1", name: "C", category: .essentials, isPacked: false, assignedTo: []),
            PackingItem(id: "4", tripId: "T1", name: "D", category: .essentials, isPacked: false, assignedTo: [])
        ]
        
        let totalItems = Double(items.count)
        let packedItems = Double(items.filter { $0.isPacked }.count)
        let progress = totalItems > 0 ? (packedItems / totalItems) : 0.0
        
        XCTAssertEqual(progress, 0.5, "2 dari 4 barang dipacking harusnya menghasilkan progress 0.5 (50%)")
    }
    
    func testViewModel_ResetForm_ShouldClearFields() {
        viewModel.newItemName = "Baju Renang"
        viewModel.selectedCategory = .electronics
        viewModel.assignmentType = .custom
        viewModel.selectedMemberIds = ["USER_1"]
        
        viewModel.resetForm()
        
        XCTAssertEqual(viewModel.newItemName, "", "Nama barang harusnya kosong")
        XCTAssertEqual(viewModel.selectedCategory, .clothing, "Kategori harus kembali ke default (.clothing)")
        XCTAssertEqual(viewModel.assignmentType, .everyone, "Tipe assignment harus kembali ke default (.everyone)")
        XCTAssertTrue(viewModel.selectedMemberIds.isEmpty, "Member yang dipilih harusnya kosong")
    }
    
    func testViewModel_ToggleMemberSelection_ShouldAddAndRemove() {
        let testId = "USER_123"
        
        viewModel.toggleMemberSelection(id: testId)
        XCTAssertTrue(viewModel.selectedMemberIds.contains(testId), "Member harus ditambahkan ke Set")
        
        viewModel.toggleMemberSelection(id: testId)
        XCTAssertFalse(viewModel.selectedMemberIds.contains(testId), "Member harus dihapus dari Set")
    }
    
    func testViewModel_ProgressPercentage_ShouldCalculateCorrectly() {
        viewModel.packingItems = [
            PackingItem(id: "1", tripId: "T1", name: "A", category: .essentials, isPacked: true, assignedTo: []),
            PackingItem(id: "2", tripId: "T1", name: "B", category: .essentials, isPacked: true, assignedTo: []),
            PackingItem(id: "3", tripId: "T1", name: "C", category: .essentials, isPacked: true, assignedTo: []),
            PackingItem(id: "4", tripId: "T1", name: "D", category: .essentials, isPacked: false, assignedTo: [])
        ]
        
        XCTAssertEqual(viewModel.progressPercentage, 75, "Progress harusnya bernilai 75")
    }
    
    func testViewModel_GetBadgeColor_ShouldReturnCorrectColor() {
        let colorEveryone = viewModel.getBadgeColor(for: ["Everyone"])
        XCTAssertEqual(colorEveryone, .gray, "Badge color untuk 'Everyone' harus abu-abu")
        
        let colorSpecific = viewModel.getBadgeColor(for: ["USER_123"])
        XCTAssertEqual(colorSpecific, .blue, "Badge color untuk user spesifik harus biru")
    }
    
    func testViewModel_GetMemberName_ShouldReturnCorrectName() {
        viewModel.tripMembers = [
            TripMember(id: "U1", name: "Budi (You)", role: "Admin", packingProgress: 0)
        ]
        
        let nameEveryone = viewModel.getMemberName(for: ["Everyone"])
        XCTAssertEqual(nameEveryone, "Everyone", "Harus me-return 'Everyone'")
        
        let nameBudi = viewModel.getMemberName(for: ["U1"])
        XCTAssertEqual(nameBudi, "Budi", "Harus me-return 'Budi' tanpa '(You)'")
        
        let nameUnassigned = viewModel.getMemberName(for: ["GHOST_ID"])
        XCTAssertEqual(nameUnassigned, "Unassigned", "Harus me-return 'Unassigned' jika ID tidak ditemukan")
    }
}
