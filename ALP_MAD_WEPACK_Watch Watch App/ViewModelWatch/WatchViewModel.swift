//
//  WatchViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//

import SwiftUI
import Combine

class WatchViewModel: ObservableObject {
    // State untuk UI Watch
    @Published var nextActivity: ItineraryActivity?
    @Published var packingItems: [PackingItem] = []
    @Published var groupReadiness: Double = 0.0
    
    let currentUserId = "USER_CACA_123" // ID milik Caca (YOU)
    
    init() {
        loadData()
    }
    
    func loadData() {
        // 1. Ambil Aktivitas Berikutnya (Ambil index pertama dari Itinerary)
        // Catatan: Karena di MockData tidak ada Rafting, ini akan otomatis menampilkan aktivitas pertama (Flight/Lunch).
        self.nextActivity = MockData.sampleActivities.first
        
        // 2. Ambil Barang Bawaan Khusus Milik "YOU" dan "Everyone"
        self.packingItems = MockData.samplePackingItems.filter {
            $0.assignedTo == "Everyone" || $0.assignedTo == currentUserId
        }
        
        // 3. Ambil Kesiapan Grup
        self.groupReadiness = MockData.sampleTrips.first?.groupProgress ?? 0.68
    }
    
    // Fungsi untuk mencentang barang di Apple Watch
    func toggleItem(id: String) {
        if let index = packingItems.firstIndex(where: { $0.id == id }) {
            packingItems[index].isPacked.toggle()
        }
    }
    
    // Helper Format Waktu (Contoh: "10:00")
    func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    // Helper Emoji berdasarkan Tipe Aktivitas
    func getEmoji(for type: ActivityType) -> String {
        switch type {
        case .transport: return "✈️"
        case .food: return "🍜"
        case .lodging: return "🏨"
        case .leisure: return "🏄" // Sesuai desain Rafting/Surfing
        case .activity: return "🎒"
        }
    }
}

// Enum tambahan jika belum ada di MockData-mu
enum ActivityType {
    case transport, food, lodging, leisure, activity
}
