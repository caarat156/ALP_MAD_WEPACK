//
//  TripListView.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import SwiftUI

struct TripListView: View {
    @State private var tripViewModel = TripViewModel()
    @State private var activityViewModel = ActivityViewModel()
    @State private var isShowingAddTrip = false
    
    // 💡 PENAMBAHAN 1: EnvironmentObject & Inisial User agar sesuai dengan MainTripView
    @EnvironmentObject var authViewModel: AuthViewModel
    var userInitials: String = "RF"
    @StateObject private var accountViewModel = AccountViewModel()
    // 💡 PENAMBAHAN 2: State untuk membuka halaman/sheet notifikasi invitation
    @State private var isShowingInvitations = false
    
    let columns = [
        GridItem(.adaptive(minimum: 300), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color(red: 0.96, green: 0.97, blue: 0.98)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // --- HEADER ---
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("My Trips")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                            
                            Text("\(tripViewModel.trips.count) trips total")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        HStack(spacing: 12) {
                            // 💡 PENAMBAHAN 3: Icon Notification / Invitation
                            Button(action: {
                                isShowingAddTrip = true
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus")
                                    Text("New Trip")
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color(red: 0.08, green: 0.15, blue: 0.25))
                                .cornerRadius(20)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                isShowingInvitations = true
                            }) {
                                Image(systemName: "bell")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                            }
                            
                            // 💡 PENAMBAHAN 4: User Profile Icon
                            NavigationLink(destination: AccountView(authViewModel: authViewModel)) {
                                Circle()
                                    .fill(Color(red: 0.08, green: 0.15, blue: 0.25))
                                    .frame(width: 30, height: 30)
                                // 💡 PERUBAHAN: Tinggal panggil avatarInitials dari accountViewModel
                                    .overlay(
                                        Text(accountViewModel.avatarInitials)
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                            }
                            // Tombol New Trip Asli
                            
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    .background(Color.white)
                    
                    // --- KONTEN BAWAH ---
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(tripViewModel.trips) { trip in
                                
                                NavigationLink(value: trip) {
                                    TripCardComponent(trip: trip, tripViewModel: tripViewModel, activityViewModel: activityViewModel)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                            }
                        }
                        .padding(.top, 15)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationDestination(for: Trip.self) { selectedTrip in
                MainTripView(trip: selectedTrip, tripViewModel: tripViewModel)
            }
            .sheet(isPresented: $isShowingAddTrip) {
                AddTripModalView(tripviewModel: tripViewModel)
            }
            // 💡 PENAMBAHAN 5: Sheet untuk memunculkan view Invitation
                        .sheet(isPresented: $isShowingInvitations) {
                            NotificationView()
                                // Opsional: Bikin sheet-nya bisa setengah layar atau full
                                .presentationDetents([.medium, .large])
                        }
            .onAppear {
                // Re-fetch ketika view muncul agar memakai UID asli yang sudah siap dari Auth
                tripViewModel.fetchTrips()
            }
        }
    }
}

#Preview {
    TripListView()
        .environmentObject(AuthViewModel()) // Tambahkan ini di preview agar tidak crash
}
