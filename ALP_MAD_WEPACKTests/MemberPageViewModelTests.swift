//
//  MemberPageViewModelTests.swift
//  ALP_MAD_WEPACK
//
//  Created by Angelique Kyra on 12/06/26.
//

import XCTest
import SwiftUI
@testable import ALP_MAD_WEPACK

final class MemberPageViewModelTests: XCTestCase {
    
    var viewModel: MemberPageViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MemberPageViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testGroupReadinessPercentage() {
        // Mock data member
        let member1 = MemberProgressUI(id: "1", name: "A", initials: "A", isYou: false, packedItems: 5, totalItems: 10, themeColor: .blue)
        let member2 = MemberProgressUI(id: "2", name: "B", initials: "B", isYou: false, packedItems: 5, totalItems: 10, themeColor: .blue)
        
        viewModel.members = [member1, member2]
        
        // Total packed = 10, Total Items = 20 -> 50%
        XCTAssertEqual(viewModel.groupReadinessPercentage, 50)
    }
    
    func testGroupReadinessPercentage_ZeroItems() {
        // Test untuk mencegah pembagian dengan 0 (Division by zero)
        let memberEmpty = MemberProgressUI(id: "3", name: "C", initials: "C", isYou: false, packedItems: 0, totalItems: 0, themeColor: .blue)
        
        viewModel.members = [memberEmpty]
        XCTAssertEqual(viewModel.groupReadinessPercentage, 0, "Harus mengembalikan 0 jika total expected item adalah 0")
    }
    
    func testMembersAlmostReadyCount() {
        // Progress di atas atau sama dengan 0.8 (80%) dihitung Almost Ready
        let readyMember = MemberProgressUI(id: "1", name: "A", initials: "A", isYou: false, packedItems: 8, totalItems: 10, themeColor: .blue) // Progress 0.8
        let notReadyMember = MemberProgressUI(id: "2", name: "B", initials: "B", isYou: false, packedItems: 5, totalItems: 10, themeColor: .blue) // Progress 0.5
        
        viewModel.members = [readyMember, notReadyMember]
        
        XCTAssertEqual(viewModel.membersAlmostReadyCount, 1)
    }
}
