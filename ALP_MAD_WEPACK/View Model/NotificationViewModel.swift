import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class NotificationViewModel: ObservableObject {
    @Published var invitations: [Invitation] = []
    private let db = Firestore.firestore()
    
    init() {
        fetchInvitations()
    }
    
    func fetchInvitations() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("invitations")
            .whereField("receiverId", isEqualTo: userId)
            .whereField("status", isEqualTo: "pending")
            .addSnapshotListener { snapshot, _ in
                self.invitations = snapshot?.documents.compactMap { try? $0.data(as: Invitation.self) } ?? []
            }
    }
    
    func acceptInvitation(invitation: Invitation) {
        // 💡 PERBAIKAN 1: Pastikan id undangan tidak nil DAN tidak kosong
        guard let id = invitation.id, !id.isEmpty else {
            print("Error: ID Dokumen Undangan kosong!")
            return
        }
        
        // 💡 PERBAIKAN 2: Pastikan tripId tidak kosong sebelum menembak ke Firebase
        guard !invitation.tripId.isEmpty else {
            print("Error: ID Trip kosong! Cek data di collection invitations.")
            return
        }
        
        // 1. Update status undangan jadi accepted
        db.collection("invitations").document(id).updateData(["status": "accepted"])
        
        // 2. Masukkan userId ke daftar member trip tersebut
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("trips").document(invitation.tripId).updateData([
            "memberIds": FieldValue.arrayUnion([userId])
        ])
    }
    
    func declineInvitation(invitation: Invitation) {
        // 💡 PERBAIKAN 3: Pastikan id undangan aman sebelum di-update
        guard let id = invitation.id, !id.isEmpty else {
            print("Error: ID Dokumen Undangan kosong!")
            return
        }
        
        db.collection("invitations").document(id).updateData(["status": "declined"])
    }
}
