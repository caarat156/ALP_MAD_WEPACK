//
//  TripViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by Angelique Kyra on 06/06/26.
//

import SwiftUI
import Observation

@Observable
class TripViewModel {
    // Cuma nyimpen data Trip
    var trips: [Trip] = []
    var currentUserID: String = "me" // Dummy user ID buat tes Owner/Member
    
    // Fungsi ngitung sisa hari
    func calculateDaysAway(from startDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTrip = calendar.startOfDay(for: startDate)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTrip)
        return max(0, components.day ?? 0)
    }
    
    // Fungsi nambah trip baru
    func createNewTrip(name: String, destination: String, start: Date, end: Date, imageData: Data?) {
        let newTrip = Trip(
            id: UUID().uuidString,
            name: name,
            destination: destination,
            startDate: start,
            endDate: end,
            ownerId: currentUserID,
            memberIds: [currentUserID],
            groupProgress: 0.0,
            customImage: imageData
        )
        trips.append(newTrip)
    }
}
