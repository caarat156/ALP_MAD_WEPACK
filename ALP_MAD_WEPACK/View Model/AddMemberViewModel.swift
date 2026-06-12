//
//  AddMemberViewModel.swift
//  ALP_MAD_WEPACK
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

class AddMemberViewModel: ObservableObject {
    @Published var inviteMethod = 0
    @Published var inviteInput = ""
    @Published var members: [GroupMemberUI] = []
    
    @Published var tripId: String = ""
    @Published var tripName: String = ""
    @Published var tripDate: String = ""
    
    private let db = Firestore.firestore()
    
    init() {
        self.members = []
    }
    
    func loadTripData(id: String, name: String, dateString: String) {
        self.tripId = id
        self.tripName = name
        self.tripDate = dateString
    }
    
    func loadCurrentUser(id: String, name: String, username: String) {
        guard !members.contains(where: { $0.id == id }) else { return }
        
        let generatedInitials = String(name.prefix(2)).uppercased()
        
        let currentUser = GroupMemberUI(
            id: id,
            name: name,
            username: username,
            initials: generatedInitials,
            isYou: true
        )
        
        members.insert(currentUser, at: 0)
    }
    
    func removeMember(id: String) {
        members.removeAll { $0.id == id }
    }
    
    func sendRequest(currentUserName: String) {
        guard !inviteInput.isEmpty else { return }
        guard let senderId = Auth.auth().currentUser?.uid else { return }
        
        let searchField = inviteMethod == 1 ? "email" : "username"
        let searchValue = inviteMethod == 1 ? inviteInput.lowercased() : "@\(inviteInput.lowercased().replacingOccurrences(of: "@", with: ""))"
        
        db.collection("users")
            .whereField(searchField, isEqualTo: searchValue)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error mencari user: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents, let userDoc = documents.first else {
                    print("User tidak ditemukan di database!")
                    return
                }
                
                let receiverId = userDoc.documentID
                let userData = userDoc.data()
                let receiverName = userData["name"] as? String ?? "New User"
                let receiverUsername = userData["username"] as? String ?? searchValue
                
                let newInvitation: [String: Any] = [
                    "tripId": self.tripId,
                    "tripName": self.tripName,
                    "senderId": senderId,
                    "senderName": currentUserName,
                    "receiverId": receiverId,
                    "status": "pending",
                    "timestamp": FieldValue.serverTimestamp()
                ]
                
                self.db.collection("invitations").addDocument(data: newInvitation) { error in
                    if let error = error {
                        print("Gagal mengirim undangan: \(error.localizedDescription)")
                    } else {
                        print("Berhasil mengirim undangan ke Firebase!")
                        
                        DispatchQueue.main.async {
                            let generatedInitials = String(receiverName.prefix(2)).uppercased()
                            let newMember = GroupMemberUI(
                                id: receiverId,
                                name: receiverName,
                                username: receiverUsername,
                                initials: generatedInitials,
                                isYou: false
                            )
                            
                            withAnimation {
                                self.members.append(newMember)
                            }
                            self.inviteInput = ""
                        }
                    }
                }
            }
    }
    
    func resetForm() {
        inviteInput = ""
    }
}
