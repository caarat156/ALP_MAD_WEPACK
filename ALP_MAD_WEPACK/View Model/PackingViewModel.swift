import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class PackingViewModel: ObservableObject {
    // --- STATE DATA ---
    @Published var packingItems: [PackingItem] = [] // Sekarang kosong di awal
    @Published var tripMembers: [TripMember] = []   // Data member asli
    @Published var showAddItemSheet = false
    
    // --- STATE FORM INPUT ---
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
    
    // --- FUNGSI FETCH REAL-TIME ---
    func fetchPackingItems() {
        db.collection("packing_items")
            .whereField("tripId", isEqualTo: "TRIP_BALI_2026") // Ganti dengan ID trip aktifmu
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting packing items: \(error)")
                    return
                }
                
                self.packingItems = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: PackingItem.self)
                } ?? []
            }
    }
    
    func fetchTripMembers() {
        // Asumsi data member ada di collection "users" atau subcollection "members"
        db.collection("users").getDocuments { snapshot, _ in
            self.tripMembers = snapshot?.documents.compactMap { doc in
                try? doc.data(as: TripMember.self)
            } ?? []
        }
    }
    
    // --- FUNCTIONS ---
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
        
        let newItem = PackingItem(
            id: nil, // Biarkan Firestore yang buat ID
            tripId: "TRIP_BALI_2026",
            name: trimmedName,
            category: selectedCategory,
            isPacked: false,
            assignedTo: finalAssignees
        )
        
        do {
            _ = try db.collection("packing_items").addDocument(from: newItem)
            resetForm()
        } catch {
            print("Error saving item: \(error)")
        }
    }
    
    func resetForm() {
        newItemName = ""
        selectedCategory = .clothing
        assignmentType = .everyone
        selectedMemberIds = []
    }
    
    // --- HELPER FUNCTIONS (Update untuk baca data Firebase) ---
    func getInisial(for id: String) -> String {
        // Sekarang mencari di tripMembers yang kita ambil dari Firebase
        if let member = tripMembers.first(where: { $0.id == id }) {
            let cleanName = member.name.replacingOccurrences(of: " (You)", with: "")
            return String(cleanName.prefix(1)).uppercased()
        }
        return "?"
    }
    
    func getBadgeColor(for id: String) -> Color {
        // Kamu bisa simpan warna di Firestore atau tentukan logikanya di sini
        return .blue
    }
}
