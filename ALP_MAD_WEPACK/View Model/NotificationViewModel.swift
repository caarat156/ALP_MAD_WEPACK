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
        guard let userId = Auth.auth().currentUser?.uid else {
            print("⚠️ DEBUG: UID nil, tidak ada user yang login saat ini.")
            return
        }
        
        db.collection("invitations")
            .whereField("receiverId", isEqualTo: userId)
            .whereField("status", isEqualTo: "pending")
            .addSnapshotListener { snapshot, error in
                
                if let error = error {
                    print("⚠️ DEBUG Firebase Error: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.invitations = snapshot?.documents.compactMap { try? $0.data(as: Invitation.self) } ?? []
                }
            }
    }
    
    func acceptInvitation(invitation: Invitation) {
        guard let id = invitation.id, !id.isEmpty else {
            print("Error: ID Dokumen Undangan kosong!")
            return
        }
        
        guard !invitation.tripId.isEmpty else {
            print("Error: ID Trip kosong! Cek data di collection invitations.")
            return
        }
        
        db.collection("invitations").document(id).updateData(["status": "accepted"])
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("trips").document(invitation.tripId).updateData([
            "memberIds": FieldValue.arrayUnion([userId])
        ])
    }
    
    func declineInvitation(invitation: Invitation) {
        guard let id = invitation.id, !id.isEmpty else {
            print("Error: ID Dokumen Undangan kosong!")
            return
        }
        
        db.collection("invitations").document(id).updateData(["status": "declined"])
    }
}
