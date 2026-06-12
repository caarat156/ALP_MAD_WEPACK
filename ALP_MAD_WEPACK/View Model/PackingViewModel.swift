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
    let trip: Trip
    
    init(trip: Trip) {
        self.trip = trip
        fetchPackingItems()
        fetchTripMembers()
    }
    
    var currentUserId: String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    var myItems: [PackingItem] {
        packingItems.filter { $0.assignedTo.contains("Everyone") || $0.assignedTo.contains(currentUserId) }
    }
    
    var packedCount: Int {
        myItems.filter { $0.packedBy.contains(currentUserId) }.count
    }
    
    var progressPercentage: Int {
        guard !myItems.isEmpty else { return 0 }
        return Int(Double(packedCount) / Double(myItems.count) * 100)
    }
    
    func fetchPackingItems() {
        db.collection("packing_items")
            .whereField("tripId", isEqualTo: trip.id)
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
                        packedBy: data["packedBy"] as? [String] ?? [],
                        assignedTo: data["assignedTo"] as? [String] ?? []
                    )
                }
            }
    }
    
    func fetchTripMembers() {
        db.collection("users").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            let allUsers = documents.map { doc in
                let data = doc.data()
                return TripMember(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "Unknown",
                    role: data["role"] as? String ?? "Member",
                    packingProgress: data["packingProgress"] as? Double ?? 0.0
                )
            }
            
            DispatchQueue.main.async {
                // 1. Filter dari database yang sesuai dengan memberIds trip ini
                var validMembers = allUsers.filter { self.trip.memberIds.contains($0.id) }
                
                // 2. Karena kode Trip punya temanmu memakai "me" secara hardcode,
                // kita buatkan akun dummy sementara agar kamu (owner) tetap muncul di pilihan.
                if self.trip.memberIds.contains("me") && !validMembers.contains(where: { $0.id == "me" }) {
                    validMembers.insert(TripMember(id: "me", name: "You (Owner)", role: "Owner", packingProgress: 0.0), at: 0)
                }
                
                self.tripMembers = validMembers
            }
        }
    }
    
    func toggleItemPacked(item: PackingItem) {
        guard let id = item.id else { return }
        let uid = currentUserId
        
        if item.packedBy.contains(uid) {
            db.collection("packing_items").document(id).updateData([
                "packedBy": FieldValue.arrayRemove([uid])
            ])
        } else {
            db.collection("packing_items").document(id).updateData([
                "packedBy": FieldValue.arrayUnion([uid])
            ])
        }
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
            "tripId": trip.id,
            "name": trimmedName,
            "category": selectedCategory.rawValue,
            "packedBy": [],
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
