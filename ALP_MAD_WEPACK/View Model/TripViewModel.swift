//
//   TripViewModel.swift
//   ALP_MAD_WEPACK
//
//   Created by MacintoshHD on 29/05/26.
//

import SwiftUI
import Observation
// import FirebaseFirestore

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


//@Observable
//class TripViewModel {

//var trips: [Trip] = []
//    var activities: [ItineraryActivity] = []
//    
//    var currentUserID: String = "USER_ACTIVE"
//    private let db = Firestore.firestore()

//    func calculateDaysAway(from startDate: Date) -> Int {
//        let calendar = Calendar.current
//        let startOfToday = calendar.startOfDay(for: Date())
//        let startOfTrip = calendar.startOfDay(for: startDate)
//        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTrip)

//        return max(0, components.day ?? 0)
//    }
//
//    func createNewTrip(name: String, destination: String, start: Date, end: Date, imageData: Data? = nil) {

//        guard !name.isEmpty && !destination.isEmpty else { return }
//        
//        let newTrip = Trip(
//            id: "TRIP_\(UUID().uuidString.prefix(6))", // Bikin ID Unik tapi pendek
//            name: name,
//            destination: destination,
//            startDate: start,
//            endDate: end,
//            ownerId: currentUserID,
//            memberIds: [currentUserID],
//            groupProgress: 0.0,
//            customImage: imageData
//        )
//
//        trips.insert(newTrip, at: 0)
//
//        do {
//            try db.collection("trips").document(newTrip.id).setData(from: newTrip)
//            print("Berhasil membuat Trip baru di Firebase!")
//        } catch {
//            print("Gagal menyimpan Trip: \(error.localizedDescription)")
//        }
//    }
//
//func addActivity(_ activity: ItineraryActivity) {
//        activities.append(activity)
//
//        activities.sort { $0.startTime < $1.startTime }
//        do {
//            try db.collection("activities").document(activity.id).setData(from: activity)
//            print("Berhasil menyimpan aktivitas baru")
//        } catch {
//            print("Gagal menyimpan : \(error.localizedDescription)")
//        }
//    }

//    func getActivities(forDay dayNumber: Int, tripStartDate: Date) -> [ItineraryActivity] {
//        return activities.filter { activity in
//            let calendar = Calendar.current
//            let startOfTrip = calendar.startOfDay(for: tripStartDate)
//            let startOfActivity = calendar.startOfDay(for: activity.startTime)
//            
//            let components = calendar.dateComponents([.day], from: startOfTrip, to: startOfActivity)
//            let activityDayNumber = (components.day ?? 0) + 1
//            
//            return activityDayNumber == dayNumber
//        }
//    }
//}

