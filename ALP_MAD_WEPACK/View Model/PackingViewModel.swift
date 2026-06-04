//
//  PackingViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class PackingViewModel: ObservableObject {
    @Published var packingItems: [PackingItem] = []
    @Published var tripMembers: [TripMember] = []
    @Published var showAddItemSheet = false
    @Published var newItemName = ""
    @Published var selectedCategory: PackingCategory = .clothing
    @Published var assignmentType: AssignmentType = .everyone
    @Published var selectedMemberIds: Set<String> = []
    
    enum AssignmentType {
        case everyone
        case custom
    }
    
    private let db = Firestore.firestore()
    
    init() {
        fetchPackingItems()
        fetchTripMembers()
    }
    var packedCount: Int {
        packingItems.filter { $0.isPacked }.count
    }
    
    var progressPercentage: Int {
        guard !packingItems.isEmpty else { return 0 }
        return Int(Double(packedCount) / Double(packingItems.count) * 100)
    }
    func fetchPackingItems() {
        db.collection("packing_items")
            .whereField("tripId", isEqualTo: "TRIP_BALI_2026")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting packing items: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else { return }
                
                self.packingItems = documents.map { document in
                    let data = document.data()
                    let categoryString = data["category"] as? String ?? "Clothing"
                    
                    return PackingItem(
                        id: document.documentID,
                        tripId: data["tripId"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        category: PackingCategory(rawValue: categoryString) ?? .clothing,
                        isPacked: data["isPacked"] as? Bool ?? false,
                        assignedTo: data["assignedTo"] as? [String] ?? []
                    )
                }
            }
    }
    
    func fetchTripMembers() {
        db.collection("users").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            self.tripMembers = documents.map { doc in
                let data = doc.data()
                return TripMember(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "Unknown",
                    role: data["role"] as? String ?? "Member",
                    packingProgress: data["packingProgress"] as? Double ?? 0.0
                )
            }
        }
    }
    
    func toggleItemPacked(item: PackingItem) {
        guard let id = item.id else { return }
        let newStatus = !item.isPacked
        
        db.collection("packing_items").document(id).updateData(["isPacked": newStatus])
    }
    
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
        
        let finalAssignees = assignmentType == .everyone ? ["Everyone"] : Array(selectedMemberIds)
        
        let itemData: [String: Any] = [
            "tripId": "TRIP_BALI_2026",
            "name": trimmedName,
            "category": selectedCategory.rawValue,
            "isPacked": false,
            "assignedTo": finalAssignees
        ]
        
        db.collection("packing_items").addDocument(data: itemData) { [weak self] error in
            if let error = error {
                print("Error saving item: \(error)")
            } else {
                self?.resetForm()
            }
        }
    }
    
    func resetForm() {
        newItemName = ""
        selectedCategory = .clothing
        assignmentType = .everyone
        selectedMemberIds = []
    }
    
    func getMemberName(for assignedTo: [String]) -> String {
        if assignedTo.contains("Everyone") { return "Everyone" }
        
        if let firstId = assignedTo.first,
           let member = tripMembers.first(where: { $0.id == firstId }) {
            return member.name.replacingOccurrences(of: " (You)", with: "")
        }
        return "Unassigned"
    }
    
    func getBadgeColor(for assignedTo: [String]) -> Color {
        return assignedTo.contains("Everyone") ? .gray : .blue
    }
    
    func getInisial(for id: String) -> String {
        if let member = tripMembers.first(where: { $0.id == id }) {
            let cleanName = member.name.replacingOccurrences(of: " (You)", with: "")
            return String(cleanName.prefix(1)).uppercased()
        }
        return "?"
    }
}
