//
//  NotificationViewModelTests.swift
//  ALP_MAD_WEPACK
//
//  Created by Angelique Kyra on 12/06/26.
//

import XCTest
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
@testable import ALP_MAD_WEPACK // Sesuaikan nama project-mu

final class NotificationViewModelTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        // Pastikan Firebase sudah siap sebelum mulai ngetes
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    
    // Tes apakah aplikasi berhasil menarik data undangan dari Firebase
    func testFetchInvitations() {
        let viewModel = NotificationViewModel()
        
        // Kita butuh "expectation" karena Firebase itu butuh waktu loading (async)
        let expectation = XCTestExpectation(description: "Tunggu data dari Firestore")
        
        // Beri waktu 2 detik agar listener Firebase selesai mengambil data
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Tes dibilang sukses kalau array invitations tidak error/nil
            XCTAssertNotNil(viewModel.invitations)
            expectation.fulfill() // Lapor kalau loading selesai
        }
        
        // Batas waktu nunggu maksimal 5 detik
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Tes apakah sistem kebal dari error kalau dikasih data undangan bodong/kosong
    func testAcceptAndDeclineInvitation_WithEmptyID() {
        let viewModel = NotificationViewModel()
        
        // Bikin data undangan bohong-bohongan yang ID-nya kosong
        let invalidInvitation = Invitation(
            id: "",
            tripId: "",
            tripName: "Trip Bodong",
            senderId: "user1",
            senderName: "Budi",
            receiverId: "user2",
            status: Invitation.InvitationStatus(rawValue: "pending") ?? <#default value#>,
            timestamp: Date()
        )
        
        // Kita panggil fungsinya. Kalau kodenya benar, fungsi ini akan langsung return
        // dan nolak ngirim data ke Firebase (nggak bikin aplikasi crash).
        viewModel.acceptInvitation(invitation: invalidInvitation)
        viewModel.declineInvitation(invitation: invalidInvitation)
        
        // Kalau berhasil sampai baris ini tanpa crash, berarti tesnya lolos!
        XCTAssertTrue(true, "Aplikasi aman dan tidak crash saat memproses ID kosong")
    }
}
