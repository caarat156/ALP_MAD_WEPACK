//
//  AuthViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var loginEmail = ""
    @Published var loginPassword = ""
    
    @Published var registerName = ""
    @Published var registerUsername = ""
    @Published var registerEmail = ""
    @Published var registerPassword = ""
    @Published var registerConfirmPassword = ""
    
    @Published var isAuthenticated = false
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = (user != nil)
            }
        }
    }
    
    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    var isLoginValid: Bool {
        return !loginEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               loginPassword.count >= 6
    }
    
    var isRegisterValid: Bool {
        return !registerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !registerUsername.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !registerEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               registerPassword.count >= 8 &&
               registerPassword == registerConfirmPassword
    }
    
    func login() {
        guard isLoginValid else { return }
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: loginEmail, password: loginPassword) { authResult, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    print("User Berhasil Login dengan UID: \(authResult?.user.uid ?? "")")
                }
            }
        }
    }
    
    func register() {
        guard isRegisterValid else { return }
        isLoading = true
        errorMessage = nil
        
        let db = Firestore.firestore()
        
        // Bersihkan username dari spasi, huruf besar, dan simbol '@' (jika user terlanjur mengetik)
        let cleanedUsername = registerUsername
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "@", with: "")
            .replacingOccurrences(of: " ", with: "")
            .lowercased()
        
        // Cek apakah username sudah ada
        db.collection("users").whereField("username", isEqualTo: cleanedUsername).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            if let docs = snapshot?.documents, !docs.isEmpty {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Username already taken. Please choose another one."
                }
                return
            }
            
            // Lanjut ke pembuatan user Auth jika username tersedia
            Auth.auth().createUser(withEmail: self.registerEmail, password: self.registerPassword) { authResult, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = error.localizedDescription
                    }
                } else {
                    guard let user = authResult?.user else { return }
                    print("User Baru Terdaftar dengan UID: \(user.uid)")
                    
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = self.registerName
                    
                    changeRequest.commitChanges { error in
                        db.collection("users").document(user.uid).setData([
                            "name": self.registerName,
                            "username": cleanedUsername,
                            "email": self.registerEmail,
                            "joinedDate": Timestamp(date: Date())
                        ]) { firestoreError in
                            DispatchQueue.main.async {
                                self.isLoading = false
                                
                                if let firestore  = firestoreError {
                                    self.errorMessage = firestore.localizedDescription
                                    print("Gagal menyimpan data ke Firestore: \(firestore.localizedDescription)")
                                } else {
                                    print("Berhasil menyimpan profil lengkap ke Firestore!")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            
            self.loginEmail = ""
            self.loginPassword = ""
            self.registerName = ""
            self.registerUsername = ""
            self.registerEmail = ""
            self.registerPassword = ""
            self.registerConfirmPassword = ""
        } catch let signOutError as NSError {
            print("Error saat mencoba sign out: %@", signOutError)
            self.errorMessage = signOutError.localizedDescription
        }
    }
}
