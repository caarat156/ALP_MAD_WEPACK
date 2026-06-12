//
//  WePack_Watch_AppApp.swift
//  WePack Watch App Watch App
//
//  Created by Angelique Kyra on 12/06/26.
//

import SwiftUI
import FirebaseCore // Wajib untuk menyalakan Firebase di Watch

@main
struct WePack_Watch_AppApp: App {
    @StateObject private var tripViewModel = TripViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if tripViewModel.trips.isEmpty {
                    Text("No trips...")
                        .onAppear { tripViewModel.fetchTrips() }
                } else {
                    List(tripViewModel.trips) { trip in
                        NavigationLink(destination: WatchView(trip: trip)) {
                            Text(trip.name)
                        }
                    }
                    .navigationTitle("My Trips")
                }
            }
        }
    }
}
