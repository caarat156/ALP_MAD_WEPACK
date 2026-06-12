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
        // Tambahkan print ini biar kamu tahu kalau dia gagal karena belum login
        guard let userId = Auth.auth().currentUser?.uid else {
            print("⚠️ DEBUG: UID nil, tidak ada user yang login saat ini.")
            return
        }
        
        db.collection("invitations")
            .whereField("receiverId", isEqualTo: userId)
            .whereField("status", isEqualTo: "pending")
            .addSnapshotListener { snapshot, error in
                
                // Tangkap error jika permission denied atau Firebase bermasalah
                if let error = error {
                    print("⚠️ DEBUG Firebase Error: \(error.localizedDescription)")
                    return
                }
                
                // 💡 SOLUSI THREAD 1: Pastikan update data @Published terjadi di Main Thread
                DispatchQueue.main.async {
                    self.invitations = snapshot?.documents.compactMap { try? $0.data(as: Invitation.self) } ?? []
                }
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
