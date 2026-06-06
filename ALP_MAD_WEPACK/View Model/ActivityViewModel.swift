//
//  ActivityViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by Angelique Kyra on 06/06/26.
//

import SwiftUI
import Observation
import FirebaseFirestore

@Observable
class ActivityViewModel {
    // Cuma nyimpen data Aktivitas
    var activities: [ItineraryActivity] = []
    
    // Inisialisasi Database Firebase HANYA untuk aktivitas
    let db = Firestore.firestore()
    
    // Fungsi nambah aktivitas
    func addActivity(_ activity: ItineraryActivity) {
        activities.append(activity)
        activities.sort { $0.startTime < $1.startTime }
        
        do {
            try db.collection("activities").document(activity.id).setData(from: activity)
            print("Berhasil menyimpan aktivitas baru")
        } catch {
            print("Gagal menyimpan : \(error.localizedDescription)")
        }
    }

    // Fungsi ngambil aktivitas per hari
    func getActivities(forDay dayNumber: Int, tripStartDate: Date) -> [ItineraryActivity] {
        return activities.filter { activity in
            let calendar = Calendar.current
            let startOfTrip = calendar.startOfDay(for: tripStartDate)
            let startOfActivity = calendar.startOfDay(for: activity.startTime)
            
            let components = calendar.dateComponents([.day], from: startOfTrip, to: startOfActivity)
            let activityDayNumber = (components.day ?? 0) + 1
            
            return activityDayNumber == dayNumber
        }
    }
}
