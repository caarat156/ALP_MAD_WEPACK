//
//  MembersModel.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//
import Foundation
import SwiftUI

// Model untuk Anggota Trip
struct MemberProgressUI: Identifiable {
    let id: String // ID menggunakan String agar cocok dengan MockData
    let name: String
    let initials: String
    let isYou: Bool
    let packedItems: Int
    let totalItems: Int
    let themeColor: Color
    
    // Logika persentase progres
    var progress: Double {
        return totalItems == 0 ? 0 : Double(packedItems) / Double(totalItems)
    }
    
    // Logika teks status berdasarkan progres
    var statusText: String {
        if progress >= 0.8 { return "ALMOST READY" }
        if progress >= 0.5 { return "IN PROGRESS" }
        return "NEEDS ACTION"
    }
    
    // Warna background status
    var statusColor: Color {
        if progress >= 0.8 { return Color.teal.opacity(0.15) }
        if progress >= 0.5 { return Color.blue.opacity(0.15) }
        return Color.gray.opacity(0.15)
    }
}

// Model untuk Kategori Barang (Agar tidak error sekalian)
struct CategoryAssignment: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let iconColor: Color
    let totalItems: Int
    let everyoneCount: Int
    let customCount: Int
    let assignedInitials: [String]
}
