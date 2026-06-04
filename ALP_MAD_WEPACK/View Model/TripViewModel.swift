//
//   TripViewModel.swift
//   ALP_MAD_WEPACK
//
//   Created by MacintoshHD on 29/05/26.
//

import SwiftUI
import Observation

@Observable
class TripViewModel {
    var trips: [Trip] = MockData.sampleTrips
    var activities: [ItineraryActivity] = MockData.sampleActivities
    
    var currentUserID: String = "USER_ACTIVE"
    
    func calculateDaysAway(from startDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTrip = calendar.startOfDay(for: startDate)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTrip)
        return max(0, components.day ?? 0)
    }
    func createNewTrip(name: String, destination: String, start: Date, end: Date, imageData: Data? = nil) {
 
        guard !name.isEmpty && !destination.isEmpty else { return }
        
        let newTrip = Trip(
            id: "TRIP_\(UUID().uuidString.prefix(6))",
            name: name,
            destination: destination,
            startDate: start,
            endDate: end,
            ownerId: currentUserID,
            memberIds: [currentUserID],
            groupProgress: 0.0,
            customImage: imageData
        )
      
        trips.insert(newTrip, at: 0)
    }
   
    func addActivity(_ activity: ItineraryActivity) {
        activities.append(activity)
       
        activities.sort { $0.startTime < $1.startTime }
    }
}
