//
//  MemberPageViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.#imageLiteral(resourceName: "Screenshot 2026-05-29 at 13.16.07.png")
//

import SwiftUI

class MemberPageViewModel: ObservableObject {
    // Data Anggota (Sesuai UI Mockup)
    @Published var members: [MemberProgressUI] = [
        // Rafi kita kasih ID "USER_CACA_123" agar nyambung ke data koper punya Caca di MockData
        MemberProgressUI(id: "USER_CACA_123", name: "Rafi", initials: "RF", isYou: true, packedItems: 14, totalItems: 15, themeColor: Color(red: 37/255, green: 45/255, blue: 67/255)),
        
        // Nadia kita kasih ID "USER_ANGEL_456" agar nyambung ke data kopernya Angel
        MemberProgressUI(id: "USER_ANGEL_456", name: "Nadia", initials: "ND", isYou: false, packedItems: 10, totalItems: 15, themeColor: Color.blue.opacity(0.7)),
        
        // Sisanya kita kasih ID dummy karena di MockData belum ada item khusus buat mereka (tapi mereka tetap dapat item "Everyone")
        MemberProgressUI(id: "USER_NDUT_789", name: "Dito", initials: "DT", isYou: false, packedItems: 9, totalItems: 15, themeColor: Color.teal),
        MemberProgressUI(id: "USER_KR_04", name: "Karina", initials: "KR", isYou: false, packedItems: 10, totalItems: 12, themeColor: Color.teal),
        MemberProgressUI(id: "USER_BM_05", name: "Bimo", initials: "BM", isYou: false, packedItems: 5, totalItems: 13, themeColor: Color.blue.opacity(0.5))
    ]
    
    // Data Kategori Barang
    @Published var categories: [CategoryAssignment] = [
        CategoryAssignment(title: "Clothing", iconName: "tshirt.fill", iconColor: Color.blue.opacity(0.5), totalItems: 6, everyoneCount: 3, customCount: 3, assignedInitials: ["R", "N", "D", "K", "B"]),
        CategoryAssignment(title: "Electronics", iconName: "powerplug.fill", iconColor: Color(red: 37/255, green: 45/255, blue: 67/255), totalItems: 5, everyoneCount: 2, customCount: 3, assignedInitials: ["R", "N", "D", "K", "B"]),
        CategoryAssignment(title: "Medical", iconName: "pill.fill", iconColor: Color.red, totalItems: 5, everyoneCount: 3, customCount: 2, assignedInitials: ["R", "N", "D", "K", "B"]),
        CategoryAssignment(title: "Operational", iconName: "list.clipboard.fill", iconColor: Color.gray, totalItems: 5, everyoneCount: 2, customCount: 3, assignedInitials: ["R", "N", "D", "K", "B"])
    ]
    
    // Kalkulasi Persentase Kesiapan Grup
    var groupReadinessPercentage: Int {
        let totalPacked = members.map { $0.packedItems }.reduce(0, +)
        let totalExpected = members.map { $0.totalItems }.reduce(0, +)
        return totalExpected == 0 ? 0 : Int((Double(totalPacked) / Double(totalExpected)) * 100)
    }
    
    // Menghitung berapa anggota yang "Almost Ready"
    var membersAlmostReadyCount: Int {
        return members.filter { $0.progress >= 0.8 }.count
    }
}
