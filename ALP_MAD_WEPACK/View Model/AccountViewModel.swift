//
//  AccountViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import PhotosUI

class AccountViewModel: ObservableObject {
    @Published var name: String = "Loading..."
    @Published var username: String = "Loading..."
    @Published var email: String = "Loading..."
    @Published var profileImage: UIImage? = nil
    
    @Published var editedName: String = ""
    @Published var editedUsername: String = ""
    @Published var editedEmail: String = ""
    @Published var editedPhone: String = ""
    @Published var editedBio: String = ""
    
    @Published var selectedPhotoItem: PhotosPickerItem? = nil {
        didSet {
            if let selectedPhotoItem {
                Task {
                    await loadSelectedPhoto(selectedPhotoItem)
                }
            }
        }
    }
    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    var avatarInitials: String {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanName.isEmpty || cleanName == "Loading..." { return "?" }
        let components = cleanName.split(separator: " ")
        let initials = components.compactMap { $0.first }.prefix(2)
        return String(initials).uppercased()
    }
    
    init() {
        fetchUserData()
    }
    
    func fetchUserData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        isLoading = true
        let db = Firestore.firestore()
        
        db.collection("users").document(currentUser.uid).getDocument { [weak self] document, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("Error fetch data: \(error.localizedDescription)")
                    return
                }
                
                if let document = document, document.exists, let data = document.data() {
                    let fetchedName = data["name"] as? String ?? "No Name"
                    let fetchedUsername = data["username"] as? String ?? "@username"
                    let fetchedEmail = currentUser.email ?? (data["email"] as? String ?? "No Email")
                    let fetchedPhone = data["phone"] as? String ?? ""
                    let fetchedBio = data["bio"] as? String ?? ""
                    
                    self?.name = fetchedName
                    self?.username = fetchedUsername
                    self?.email = fetchedEmail
                    
                    self?.editedName = fetchedName
                    self?.editedUsername = fetchedUsername.replacingOccurrences(of: "@", with: "")
                    self?.editedEmail = fetchedEmail
                    self?.editedPhone = fetchedPhone
                    self?.editedBio = fetchedBio
                }
            }
        }
    }
    
    func saveProfile() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        let finalUsername = editedUsername.hasPrefix("@") ? editedUsername : "@\(editedUsername)"
        
        let updatedData: [String: Any] = [
            "name": editedName,
            "username": finalUsername,
            "email": editedEmail,
            "phone": editedPhone,
            "bio": editedBio
        ]
        
        db.collection("users").document(currentUser.uid).updateData(updatedData) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error saving profile: \(error.localizedDescription)")
                } else {
                    print("Profile updated successfully!")
                    self?.name = self?.editedName ?? ""
                    self?.username = finalUsername
                    self?.email = self?.editedEmail ?? ""
                }
            }
        }
    }
    
    @MainActor
    private func loadSelectedPhoto(_ photoItem: PhotosPickerItem) async {
        do {
            if let data = try await photoItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                self.profileImage = image
            }
        } catch {
            print("Gagal memuat foto: \(error.localizedDescription)")
        }
    }
}
