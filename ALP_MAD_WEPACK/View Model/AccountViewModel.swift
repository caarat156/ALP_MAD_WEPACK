//
//  AccountViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import Foundation
import SwiftUI
import PhotosUI
class AccountViewModel: ObservableObject {
    // --- DATA PROFIL UTAMA ---
    @Published var name: String = "Caca"
    @Published var username: String = "caca_wepack" // Hapus tanda '@' di sini karena nanti di UI sudah otomatis ditambahin prefix "@"
    @Published var email: String = "caca@student.uc.ac.id"
    @Published var phone: String = "+62 812 3456 7890" // Sekarang data phone sudah ada di ViewModel
    @Published var bio: String = "Ready for the next adventure! ✈️"
    
    // FOTO PROFIL
    @Published var profileImage: UIImage? = nil
    @Published var photosPickerItem: PhotosPickerItem? = nil {
        didSet {
            loadImageFromPicker()
        }
    }
    
    // DATA STATISTIK
    @Published var totalTrips: Int = 3
    @Published var totalItemsPacked: Int = 12
    
    // STATE MODAL / FORM EDIT (Lengkap untuk semua fields)
    @Published var showEditSheet: Bool = false
    @Published var editedName: String = ""
    @Published var editedUsername: String = ""
    @Published var editedEmail: String = ""
    @Published var editedPhone: String = ""
    @Published var editedBio: String = ""
    
    // Fungsi mencatat data lama ke data edit sebelum form dibuka
    func prepareEditForm() {
        editedName = name
        editedUsername = username
        editedEmail = email
        editedPhone = phone
        editedBio = bio
    }
    
    // Fungsi buat mindahin data dari form edit ke data utama pas tombol "Save Changes" ditekan
    func saveProfile() {
        let trimmedName = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            name = trimmedName
        }
        
        let trimmedUsername = editedUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedUsername.isEmpty {
            username = trimmedUsername
        }
        
        let trimmedEmail = editedEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedEmail.isEmpty {
            email = trimmedEmail
        }
        
        phone = editedPhone
        bio = editedBio
    }
    
    var avatarInitials: String {
        return String(name.prefix(1)).uppercased()
    }
    
    private func loadImageFromPicker() {
        guard let item = photosPickerItem else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data, let uiImage = UIImage(data: data) {
                        self.profileImage = uiImage
                    }
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }
    }
}
