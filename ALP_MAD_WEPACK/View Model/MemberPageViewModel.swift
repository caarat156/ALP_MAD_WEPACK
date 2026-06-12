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
    private let db = Firestore.firestore()
    
    func fetchMembersData(tripId: String) {
        db.collection("trips").document(tripId).collection("members").getDocuments { snapshot, error in
            
            if let error = error {
                print("Gagal mengambil data member: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Tidak ada member di trip ini.")
                return
            }
            
            DispatchQueue.main.async {
                self.members = documents.compactMap { doc -> MemberProgressUI? in
                    let data = doc.data()
                    
                    let name = data["name"] as? String ?? "Unknown"
                    let initials = data["initials"] as? String ?? ""
                    let isYou = data["id"] as? String == "USER_CURRENT_ID"
                    let packedItems = data["packedItems"] as? Int ?? 0
                    let totalItems = data["totalItems"] as? Int ?? 0
                    
                    return MemberProgressUI(
                        id: doc.documentID,
                        name: name,
                        initials: initials,
                        isYou: isYou,
                        packedItems: packedItems,
                        totalItems: totalItems,
                        themeColor: Color.blue
                    )
                }
            }
        }
    }
}
