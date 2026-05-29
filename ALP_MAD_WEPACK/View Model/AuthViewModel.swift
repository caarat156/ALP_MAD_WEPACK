//
//  AuthViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import Foundation
import SwiftUI
import FirebaseAuth

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
        // Jika di device sudah pernah login sebelumnya, Firebase akan otomatis mengingat session user
        if Auth.auth().currentUser != nil {
            self.isAuthenticated = true
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
            // Kembalikan ke main thread untuk mengupdate UI
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    // Firebase memberikan pesan error bawaan (misal: password salah atau email tidak terdaftar)
                    self.errorMessage = error.localizedDescription
                } else {
                    // Berhasil login!
                    self.isAuthenticated = true
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
            DispatchQueue.main.async {
                if let error = error {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                } else {
                    // Berhasil membuat akun di Firebase Auth!
                    print("User Baru Terdaftar dengan UID: \(authResult?.user.uid ?? "")")
                    
                    // TIPS TAMBAHAN: Update nama user di profil Firebase Auth
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.registerName
                    
                    changeRequest?.commitChanges { error in
                        DispatchQueue.main.async {
                            self.isLoading = false
                            // Setelah sukses simpan nama, langsung tandai user telah terautentikasi
                            self.isAuthenticated = true
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
            self.isAuthenticated = false
            
            // Bersihkan sisa data form demi keamanan
            self.loginEmail = ""
            self.loginPassword = ""
            self.registerPassword = ""
            self.registerConfirmPassword = ""
        } catch let signOutError as NSError {
            print("Error saat mencoba sign out: %@", signOutError)
            self.errorMessage = signOutError.localizedDescription
        }
    }
}
