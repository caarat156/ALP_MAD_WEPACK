//
//  MemberPageViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.#imageLiteral(resourceName: "Screenshot 2026-05-29 at 13.16.07.png")
//

import SwiftUI
import FirebaseFirestore

class MemberPageViewModel: ObservableObject {
    @Published var members: [MemberProgressUI] = []
    @Published var categories: [CategoryAssignment] = []
    @Published var packingItems: [PackingItem] = []
    
    var groupReadinessPercentage: Int {
        let totalPacked = members.map { $0.packedItems }.reduce(0, +)
        let totalExpected = members.map { $0.totalItems }.reduce(0, +)
        return totalExpected == 0 ? 0 : Int((Double(totalPacked) / Double(totalExpected)) * 100)
    }
    
    var membersAlmostReadyCount: Int {
        return members.filter { $0.progress >= 0.8 }.count
    }
    // Inisialisasi Database
    private let db = Firestore.firestore()
    
    // Fungsi untuk menarik data dari Firebase
    func fetchMembersData(tripId: String) {
        // Asumsi struktur temanmu: koleksi "trips" -> dokumen "tripId" -> koleksi "members"
        db.collection("trips").document(tripId).collection("members").getDocuments { snapshot, error in
            
            // 1. Cek apakah ada error koneksi
            if let error = error {
                print("Gagal mengambil data member: \(error.localizedDescription)")
                return
            }
            
            // 2. Pastikan datanya tidak kosong
            guard let documents = snapshot?.documents else {
                print("Tidak ada member di trip ini.")
                return
            }
            
            // 3. Ubah data mentah Firebase menjadi array model SwiftUI-mu
            DispatchQueue.main.async {
                self.members = documents.compactMap { doc -> MemberProgressUI? in
                    let data = doc.data()
                    
                    // Tarik data dari field Firebase (contoh)
                    let name = data["name"] as? String ?? "Unknown"
                    let initials = data["initials"] as? String ?? ""
                    let isYou = data["id"] as? String == "USER_CURRENT_ID" // Ganti dengan logika deteksi user login
                    let packedItems = data["packedItems"] as? Int ?? 0
                    let totalItems = data["totalItems"] as? Int ?? 0
                    
                    return MemberProgressUI(
                        id: doc.documentID,
                        name: name,
                        initials: initials,
                        isYou: isYou,
                        packedItems: packedItems,
                        totalItems: totalItems,
                        themeColor: Color.blue // Bisa disesuaikan nanti
                    )
                }
            }
        }
    }
}
