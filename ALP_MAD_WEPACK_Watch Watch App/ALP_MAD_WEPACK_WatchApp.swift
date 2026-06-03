//
//  ALP_MAD_WEPACK_WatchApp.swift
//  ALP_MAD_WEPACK_Watch Watch App
//
//  Created by student on 29/05/26.
//

import SwiftUI
import FirebaseCore

@main
struct ALP_MAD_WEPACK_Watch_Watch_AppApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            WatchContentView()
        }
    }
}
