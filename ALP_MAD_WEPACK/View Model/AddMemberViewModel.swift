//
//  AddMemberViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//
import SwiftUI
import Combine

class AddMemberViewModel: ObservableObject {
    @Published var inviteMethod = 0
    @Published var inviteInput = ""
    @Published var members: [GroupMemberUI] = []
    
    // 💡 PERUBAHAN 1: Hapus data dummy, ganti jadi string kosong
    @Published var tripName: String = ""
    @Published var tripDate: String = ""
    
    init() {
        self.members = []
    }
    
    // 💡 PERUBAHAN 2: Fungsi untuk memuat data Trip asli
    func loadTripData(name: String, dateString: String) {
        self.tripName = name
        self.tripDate = dateString
    }
    
    // Fungsi untuk memasukkan user yang sedang login ke dalam list
    func loadCurrentUser(id: String, name: String, username: String) {
        // Cek agar tidak duplikat
        guard !members.contains(where: { $0.id == id }) else { return }
        
        // Ambil 2 huruf pertama untuk inisial secara dinamis
        let generatedInitials = String(name.prefix(2)).uppercased()
        
        let currentUser = GroupMemberUI(
            id: id,
            name: name,
            username: username,
            initials: generatedInitials,
            isYou: true
        )
        
        // Pastikan user current selalu ada di urutan paling atas
        members.insert(currentUser, at: 0)
    }
    
    func removeMember(id: String) {
        members.removeAll { $0.id == id }
    }
    
    func sendRequest() {
        var extractedName = ""
        var newUsername = ""
        
        if inviteMethod == 1 {
            let emailParts = inviteInput.components(separatedBy: "@")
            extractedName = emailParts.first?.capitalized ?? "New User"
            newUsername = "@\(extractedName.lowercased())"
        } else {
            let cleanInput = inviteInput.replacingOccurrences(of: "@", with: "")
            extractedName = cleanInput.capitalized
            newUsername = "@\(cleanInput.lowercased())"
        }
        
        let generatedInitials = String(extractedName.prefix(2)).uppercased()
        
        let newMember = GroupMemberUI(
            id: UUID().uuidString,
            name: extractedName,
            username: newUsername,
            initials: generatedInitials,
            isYou: false
        )
        
        withAnimation {
            members.append(newMember)
        }
        
        inviteInput = ""
    }
    
    func resetForm() {
        inviteInput = ""
    }
}
