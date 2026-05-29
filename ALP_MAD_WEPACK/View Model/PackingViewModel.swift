//
//  PackingViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import Foundation
import SwiftUI
class PackingViewModel: ObservableObject {
    // --- STATE DATA ---
    @Published var packingItems: [PackingItem] = MockData.samplePackingItems
    @Published var showAddItemSheet = false
    
    // --- STATE FORM INPUT (LOGIC MULTI-SELECT) ---
    @Published var newItemName = ""
    @Published var selectedCategory: PackingCategory = .clothing
    @Published var assignmentType: AssignmentType = .everyone // Default: Everyone
    @Published var selectedMemberIds: Set<String> = []        // Menampung banyak member terpilih
    
    enum AssignmentType {
        case everyone
        case custom
    }
    
    // --- KALKULASI DATA ---
    var packedCount: Int {
        packingItems.filter { $0.isPacked }.count
    }
    
    var progressPercentage: Int {
        guard !packingItems.isEmpty else { return 0 }
        return Int(Double(packedCount) / Double(packingItems.count) * 100)
    }
    
    // --- FUNCTIONS ---
    func toggleItemPacked(item: PackingItem) {
        if let index = packingItems.firstIndex(where: { $0.id == item.id }) {
            packingItems[index].isPacked.toggle()
        }
    }
    
    // Logika pilih/batal pilih member di grid
    func toggleMemberSelection(id: String) {
        if selectedMemberIds.contains(id) {
            selectedMemberIds.remove(id)
        } else {
            selectedMemberIds.insert(id)
        }
    }
    
    func saveNewItem() {
        let trimmedName = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        // Tentukan isi array berdasarkan opsi yang dipilih
        let finalAssignees = assignmentType == .everyone ? ["Everyone"] : Array(selectedMemberIds)
        if assignmentType == .custom && finalAssignees.isEmpty { return } // Gak bisa save kalau custom tapi kosong
        
        let newItem = PackingItem(
            id: "ITEM_\(UUID().uuidString.prefix(5))",
            tripId: "TRIP_BALI_2026",
            name: trimmedName,
            category: selectedCategory,
            isPacked: false,
            assignedTo: finalAssignees
        )
        
        packingItems.append(newItem)
        resetForm()
    }
    
    func resetForm() {
        newItemName = ""
        selectedCategory = .clothing
        assignmentType = .everyone
        selectedMemberIds = []
    }
    
    // Fungsi mengambil inisial nama member untuk bulatan kecil di list (misal: "Caca" -> "C")
    func getInisial(for id: String) -> String {
        if let member = MockData.sampleTripMembers.first(where: { $0.id == id }) {
            let cleanName = member.name.replacingOccurrences(of: " (You)", with: "")
            return String(cleanName.prefix(1)).uppercased()
        }
        return "?"
    }
    
    func getBadgeColor(for id: String) -> Color {
        switch id {
        case "USER_CACA_123": return .blue
        case "USER_ANGEL_456": return .purple
        case "USER_NDUT_789": return .indigo
        default: return .teal
        }
    }
}
