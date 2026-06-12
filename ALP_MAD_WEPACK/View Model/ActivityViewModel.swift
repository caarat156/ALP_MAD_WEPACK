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
        // 2. Simpan ke database
        do {
            try db.collection("activities").document(activity.id).setData(from: activity) { error in
                if let error = error {
                    // Error dari server Firebase akan ketahuan di sini
                    print("Gagal menyimpan ke server: \(error.localizedDescription)")
                } else {
                    print("Berhasil menyimpan aktivitas baru ke server!")
                }
            }
        } catch {
            // Ini hanya menangkap error proses encode data lokal
            print("Gagal encode data: \(error.localizedDescription)")
        }
        // Gak perlu .append manual di sini, karena listener di atas bakal otomatis update UI
    }
    
    // Fungsi untuk mendengarkan perubahan data secara real-time dari Firebase
        func listenToActivities(forTrip tripId: String) {
            db.collection("activities")
                .whereField("tripId", isEqualTo: tripId)
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        print("❌ Error mendengarkan data: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        print("⚠️ Dokumen kosong")
                        return
                    }
                    
                    self.activities = documents.compactMap { document -> ItineraryActivity? in
                        do {
                            // Coba paksa decode supaya error aslinya ketahuan
                            return try document.data(as: ItineraryActivity.self)
                        } catch {
                            // Kalau gagal, error aslinya bakal di-print dengan jelas di sini!
                            print("❌ GAGAL DECODE (ID: \(document.documentID)): \(error)")
                            return nil
                        }
                    }
                    print("✅ Berhasil memuat \(self.activities.count) aktivitas untuk trip ini.")
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
    
    func getDayNumber(for activityDate: Date, tripStartDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfTrip = calendar.startOfDay(for: tripStartDate)
        let startOfActivity = calendar.startOfDay(for: activityDate)
        let components = calendar.dateComponents([.day], from: startOfTrip, to: startOfActivity)
        return (components.day ?? 0) + 1
    }

    // Fungsi grouping yang bisa dipanggil langsung oleh View
    func getActivitiesGroupedByDay(forTrip trip: Trip) -> [Int: [ItineraryActivity]] {
        let activitiesForThisTrip = activities.filter { $0.tripId == trip.id }
        return Dictionary(grouping: activitiesForThisTrip) { getDayNumber(for: $0.startTime, tripStartDate: trip.startDate) }
    }
}
