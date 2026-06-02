//
//  ALP_MAD_WEPACKApp.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 22/05/26.
//

import SwiftUI
import FirebaseCore

@main
struct ALP_MAD_WEPACKApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                MainTripView()
                    .environmentObject(authViewModel)
            } else {
                LoginView(authViewModel: authViewModel)
            }
        }
    }
}
