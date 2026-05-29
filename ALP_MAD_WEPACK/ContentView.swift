//
//  ContentView.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 22/05/26.
//

import SwiftUI

struct ContentView: View {
    // 📢 Inisialisasi ViewModel utama di sini sekali saja
    // Karena pakai @Observable, kita gunakan @State untuk menyimpannya
    @State private var viewModel = TripViewModel()
    
    var body: some View {
        // Langsung arahkan ke TripListView sebagai halaman pertama saat aplikasi dibuka
        TripListView()
            // Kita bisa menggunakan .environment jika ingin melempar viewModel ke seluruh anak view,
            // tapi karena di kodemu kamu oper manual lewat parameter, ini sudah cukup.
    }
}

#Preview {
    ContentView()
}
