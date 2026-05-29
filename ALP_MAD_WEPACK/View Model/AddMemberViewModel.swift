//
//  AddMemberViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//

import SwiftUI

class AddMemberViewModel: ObservableObject {
    // State untuk input form
    @Published var inviteMethod = 0 // 0 = Username, 1 = Email
    @Published var inviteInput = ""
    
    // Data list anggota yang mengambil tipe dari GroupMemberUI
    @Published var members: [GroupMemberUI] = []
    
    // Ambil data trip pertama dari MockData
    let currentTrip = MockData.sampleTrips.first!
    
    init() {
        loadDataFromMock()
    }
    
    // Memproses MockData menjadi data yang siap ditayangkan di UI
    private func loadDataFromMock() {
        self.members = MockData.sampleTripMembers.map { tripMember in
            // Mendeteksi apakah ini user yang sedang login (You)
            let isCurrent = tripMember.id == "USER_CACA_123" || tripMember.name.contains("(You)")
            
            // Membersihkan nama dari embel-embel "(You)" yang ada di MockData
            let cleanName = tripMember.name.replacingOccurrences(of: " (You)", with: "")
            
            // Membuat dummy username dan inisial secara otomatis
            let generatedUsername = "@\(cleanName.lowercased().replacingOccurrences(of: " ", with: ""))"
            let generatedInitials = String(cleanName.prefix(2)).uppercased()
            
            return GroupMemberUI(
                id: tripMember.id,
                name: cleanName,
                username: generatedUsername,
                initials: generatedInitials,
                isYou: isCurrent
            )
        }
    }
    
    // Fungsi untuk menghapus member
    func removeMember(id: String) {
        members.removeAll { $0.id == id }
    }
    
    // Fungsi simulasi kirim undangan
    func sendRequest() {
        print("Mengirim undangan ke: \(inviteInput) via \(inviteMethod == 0 ? "Username" : "Email")")
        // Reset input setelah tombol ditekan
        inviteInput = ""
    }
    
    // Helper untuk memformat tanggal trip dari MockData (Contoh: "Jun 14–18, 2026")
    func getFormattedTripDate() -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM d"
        let startString = formatter.string(from: currentTrip.startDate)
        
        formatter.dateFormat = "d, yyyy"
        let endString = formatter.string(from: currentTrip.endDate)
        
        return "\(startString)–\(endString)"
    }
    
    // Tambahkan fungsi ini di dalam class AddMemberViewModel
    func resetForm() {
        inviteInput = ""
    }
}
