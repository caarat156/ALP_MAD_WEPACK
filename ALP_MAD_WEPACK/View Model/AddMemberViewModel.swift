//
//  AddMemberViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//
import SwiftUI
import Combine

class AddMemberViewModel: ObservableObject {
    // State untuk input form
    @Published var inviteMethod = 0 // 0 = Username, 1 = Email
    @Published var inviteInput = ""
    
    // Data list anggota (sekarang dinamis, murni dari state)
    @Published var members: [GroupMemberUI] = []
    
    // Variabel pengganti MockData untuk Info Trip
    @Published var tripName: String = "Bali Group Adventure"
    @Published var tripDate: String = "Jun 14–17, 2026"
    
    init() {
        // Di aplikasi asli, fungsi ini dipakai untuk nge-fetch data dari Backend/Database.
        // Untuk sekarang, kita inisialisasi dengan 1 member awal yaitu "YOU".
        let currentUser = GroupMemberUI(
            id: "USER_CURRENT",
            name: "Rafi",
            username: "@rafi",
            initials: "RF",
            isYou: true
        )
        self.members = [currentUser]
    }
    
    // Fungsi untuk menghapus member
    func removeMember(id: String) {
        members.removeAll { $0.id == id }
    }
    
    // Fungsi memproses inputan asli dari user
    func sendRequest() {
        var extractedName = ""
        var newUsername = ""
        
        if inviteMethod == 1 {
            // Jika via Email: Ambil kata sebelum '@'
            let emailParts = inviteInput.components(separatedBy: "@")
            extractedName = emailParts.first?.capitalized ?? "New User"
            newUsername = "@\(extractedName.lowercased())"
        } else {
            // Jika via Username: Hapus '@'
            let cleanInput = inviteInput.replacingOccurrences(of: "@", with: "")
            extractedName = cleanInput.capitalized
            newUsername = "@\(cleanInput.lowercased())"
        }
        
        // Buat inisial 2 huruf pertama
        let generatedInitials = String(extractedName.prefix(2)).uppercased()
        
        // Masukkan data inputan menjadi Member Baru
        let newMember = GroupMemberUI(
            id: UUID().uuidString,
            name: extractedName,
            username: newUsername,
            initials: generatedInitials,
            isYou: false
        )
        
        // Tambahkan ke UI dengan animasi
        withAnimation {
            members.append(newMember)
        }
        
        // Reset input form
        inviteInput = ""
    }
    
    // Fungsi reset saat tombol cancel ditekan
    func resetForm() {
        inviteInput = ""
    }
}
