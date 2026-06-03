//
//  WatchViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class WatchViewModel: ObservableObject {
    // State untuk UI Watch
    @Published var nextActivity: ItineraryActivity?
    @Published var packingItems: [PackingItem] = []
    @Published var groupReadiness: Double = 0.0
    
    // Ambil ID user yang sedang login secara dinamis
    var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    private let db = Firestore.firestore()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        // 1. Ambil Aktivitas Berikutnya (Manual Mapping)
        db.collection("itinerary_activities")
            .whereField("tripId", isEqualTo: "TRIP_BALI_2026")
            .limit(to: 1)
            .addSnapshotListener { snapshot, _ in
                guard let doc = snapshot?.documents.first else { return }
                let data = doc.data()
                
                self.nextActivity = ItineraryActivity(
                    id: doc.documentID,
                    tripId: data["tripId"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    startTime: (data["startTime"] as? Timestamp)?.dateValue() ?? Date(),
                    endTime: (data["endTime"] as? Timestamp)?.dateValue(),
                    location: data["location"] as? String ?? "",
                    type: ActivityType(rawValue: data["type"] as? String ?? "Leisure") ?? .leisure
                )
            }
        
        // 2. Ambil Barang Bawaan (Manual Mapping & Filtering)
        db.collection("packing_items")
            .whereField("tripId", isEqualTo: "TRIP_BALI_2026")
            .addSnapshotListener { snapshot, _ in
                guard let docs = snapshot?.documents else { return }
                let loggedInId = self.currentUserId ?? ""
                
                self.packingItems = docs.map { doc in
                    let data = doc.data()
                    let categoryString = data["category"] as? String ?? "Essentials"
                    
                    return PackingItem(
                        id: doc.documentID,
                        tripId: data["tripId"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        category: PackingCategory(rawValue: categoryString) ?? .essentials,
                        isPacked: data["isPacked"] as? Bool ?? false,
                        assignedTo: data["assignedTo"] as? [String] ?? []
                    )
                }.filter { item in
                    // Filter: Hanya tampilkan barang untuk "Everyone" atau barang user ini
                    item.assignedTo.contains("Everyone") || item.assignedTo.contains(loggedInId)
                }
            }
        
        // 3. Ambil Kesiapan Grup
        db.collection("trips").document("TRIP_BALI_2026")
            .addSnapshotListener { snapshot, _ in
                let data = snapshot?.data()
                self.groupReadiness = data?["groupProgress"] as? Double ?? 0.68
            }
    }
    
    // Fungsi untuk mencentang barang (Update ke Firebase)
    func toggleItem(id: String) {
        if let item = packingItems.first(where: { $0.id == id }) {
            let newStatus = !item.isPacked
            db.collection("packing_items").document(id).updateData(["isPacked": newStatus])
        }
    }
    
    // Helper Format Waktu
    func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    // Helper Emoji
    func getEmoji(for type: ActivityType) -> String {
        switch type {
        case .transport: return "✈️"
        case .food: return "🍜"
        case .lodging: return "🏨"
        case .leisure: return "🏄"
        case .attraction: return "🎒"
        }
    }
}
