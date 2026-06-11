import SwiftUI
import FirebaseFirestore
class NotificationViewModel: ObservableObject {
    @Published var invitations: [Invitation] = []

    func fetchInvitations() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        // Ambil data dari Firestore dimana recipientId == uid & status == "pending"
    }

    func acceptInvite(invitation: Invitation) {
        // 1. Update status di Firestore collection "trips" -> member list jadi .accepted
        // 2. Hapus dokumen di collection "notifications"
    }

    func declineInvite(invitation: Invitation) {
        // 1. Hapus user dari member list di "trips"
        // 2. Hapus dokumen di collection "notifications"
    }
}
