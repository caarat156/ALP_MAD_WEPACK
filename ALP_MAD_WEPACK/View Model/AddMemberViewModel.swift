//
//  AddMemberViewModel.swift
//  ALP_MAD_WEPACK
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth // 💡 Jangan lupa import Auth

class AddMemberViewModel: ObservableObject {
    @Published var inviteMethod = 0 // 0 untuk Username, 1 untuk Email
    @Published var inviteInput = ""
    @Published var members: [GroupMemberUI] = []
    
    @Published var tripId: String = "" // 💡 PENAMBAHAN 1: Butuh ID Trip untuk undangan
    @Published var tripName: String = ""
    @Published var tripDate: String = ""
    
    private let db = Firestore.firestore()
    
    init() {
        self.members = []
    }
    
    // 💡 PERUBAHAN 2: Tambahkan parameter id agar kita tahu trip mana yang sedang dibuka
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
    
    // 💡 PERUBAHAN 3: Rombak total fungsi sendRequest agar nyambung ke Firebase
    func sendRequest(currentUserName: String) { // Butuh nama pengirim untuk notif
        guard !inviteInput.isEmpty else { return }
        guard let senderId = Auth.auth().currentUser?.uid else { return }
        
        let searchField = inviteMethod == 1 ? "email" : "username"
        let searchValue = inviteMethod == 1 ? inviteInput.lowercased() : "@\(inviteInput.lowercased().replacingOccurrences(of: "@", with: ""))"
        
        // 1. Cari user di Firestore collection "users"
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
                    // TODO: Tambahkan State untuk memunculkan Alert "User Not Found" ke layar
                    return
                }
                
                // 2. Ambil data asli dari user yang ditemukan
                let receiverId = userDoc.documentID // Ini UID aslinya User 2!
                let userData = userDoc.data()
                let receiverName = userData["name"] as? String ?? "New User"
                let receiverUsername = userData["username"] as? String ?? searchValue
                
                // 3. Buat dokumen Invitation untuk dikirim ke Firebase
                let newInvitation: [String: Any] = [
                    "tripId": self.tripId,
                    "tripName": self.tripName,
                    "senderId": senderId,
                    "senderName": currentUserName,
                    "receiverId": receiverId,
                    "status": "pending",
                    "timestamp": FieldValue.serverTimestamp()
                ]
                
                // 4. Simpan ke Firebase
                self.db.collection("invitations").addDocument(data: newInvitation) { error in
                    if let error = error {
                        print("Gagal mengirim undangan: \(error.localizedDescription)")
                    } else {
                        print("Berhasil mengirim undangan ke Firebase!")
                        
                        // 5. Jika sukses di database, baru update UI secara lokal
                        DispatchQueue.main.async {
                            let generatedInitials = String(receiverName.prefix(2)).uppercased()
                            let newMember = GroupMemberUI(
                                id: receiverId, // Sekarang pakai ID asli dari Firebase
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
