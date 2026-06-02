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
    // --- STATE LOGIN ---
    @Published var loginEmail = ""
    @Published var loginPassword = ""
    
    // --- STATE REGISTER ---
    @Published var registerName = ""
    @Published var registerUsername = ""
    @Published var registerEmail = ""
    @Published var registerPassword = ""
    @Published var registerConfirmPassword = ""
    
    // --- STATE UI / NAVIGASI ---
    @Published var isAuthenticated = false // True jika user terdeteksi sudah login di Firebase
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    // Inisialisasi awal untuk mengecek status login user secara otomatis
    init() {
        // Listener ini akan terus memantau apakah ada user yang sedang aktif
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = (user != nil)
            }
        }
    }
    
    // --- VALIDASI INPUT ---
    var isLoginValid: Bool {
        return !loginEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               loginPassword.count >= 6
    }
    
    var isRegisterValid: Bool {
        return !registerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !registerUsername.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !registerEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               registerPassword.count >= 8 && // Menyesuaikan hint mockup "Min. 8 characters"
               registerPassword == registerConfirmPassword
    }
    
    // --- ACTIONS: LOGIN KE FIREBASE ---
    func login() {
        guard isLoginValid else { return }
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: loginEmail, password: loginPassword) { authResult, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    // Firebase memberikan pesan error bawaan (misal: password salah atau email tidak terdaftar)
                    self.errorMessage = error.localizedDescription
                } else {
                    // Berhasil login! (Status isAuthenticated akan otomatis diubah oleh listener di init)
                    print("User Berhasil Login dengan UID: \(authResult?.user.uid ?? "")")
                }
            }
        }
    }
    
    // --- ACTIONS: REGISTER KE FIREBASE ---
    func register() {
        guard isRegisterValid else { return }
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: registerEmail, password: registerPassword) { authResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            } else {
                guard let user = authResult?.user else { return }
                print("User Baru Terdaftar dengan UID: \(user.uid)")
                
                // 1. Update Display Name di profil Firebase Auth bawaan
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = self.registerName
                
                changeRequest.commitChanges { error in
                    // 2. Simpan Data Lengkap (Termasuk Username) ke Firebase Firestore
                    let db = Firestore.firestore()
                    db.collection("users").document(user.uid).setData([
                        "name": self.registerName,
                        "username": self.registerUsername,
                        "email": self.registerEmail,
                        "joinedDate": Timestamp(date: Date())
                    ]) { firestoreError in
                        DispatchQueue.main.async {
                            self.isLoading = false
                            
                            if let firestoreError = firestoreError {
                                self.errorMessage = firestoreError.localizedDescription
                                print("Gagal menyimpan data ke Firestore: \(firestoreError.localizedDescription)")
                            } else {
                                print("Berhasil menyimpan profil lengkap ke Firestore!")
                                // Jika sukses, loading berhenti.
                                // Untuk 'self.isAuthenticated = true' tidak perlu diketik ulang karena
                                // listener `addStateDidChangeListener` di init() akan otomatis
                                // mendeteksi user masuk dan langsung mengarahkan layar ke MainTripView.
                            }
                        }
                    }
                }
            }
        }
    }
    
    // --- ACTIONS: LOGOUT DARI FIREBASE ---
    func logout() {
        do {
            try Auth.auth().signOut()
            // Listener di init() otomatis mendeteksi signout dan membuat isAuthenticated = false
            
            // Bersihkan sisa data form demi keamanan
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
