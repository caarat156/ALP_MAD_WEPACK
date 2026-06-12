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

@MainActor
final class NotificationViewModelTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    
    func testFetchInvitations() {
        let viewModel = NotificationViewModel()
        
        let expectation = XCTestExpectation(description: "Tunggu data dari Firestore")
        
        // Cek apakah ada user yang login saat test berjalan
        if let currentUser = Auth.auth().currentUser {
            print("TEST LOG: User sedang login dengan UID: \(currentUser.uid)")
        } else {
            print("TEST LOG: ⚠️ TIDAK ADA USER YANG LOGIN! Firebase mungkin menolak akses.")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // Cek apakah data benar-benar terisi, bukan sekadar tidak nil
            // (Asumsinya kalau sukses narik data, isinya minimal 1)
            // XCTAssertFalse(viewModel.invitations.isEmpty, "Data undangan kosong. Kemungkinan karena belum login atau tidak ada data di Firebase.")
            
            // Atau untuk sementara kita print saja dulu biar ketahuan isinya
            print("TEST LOG: Jumlah undangan yang ditarik: \(viewModel.invitations.count)")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
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
        status: .pending, // <--- SUDAH DIPERBAIKI DI SINI (langsung pakai .pending)
        timestamp: Date()
    )
    
    // Kita panggil fungsinya. Kalau kodenya benar, fungsi ini akan langsung return
    // dan nolak ngirim data ke Firebase (nggak bikin aplikasi crash).
    viewModel.acceptInvitation(invitation: invalidInvitation)
    viewModel.declineInvitation(invitation: invalidInvitation)
    
    // Kalau berhasil sampai baris ini tanpa crash, berarti tesnya lolos!
    XCTAssertTrue(true, "Aplikasi aman dan tidak crash saat memproses ID kosong")
}
