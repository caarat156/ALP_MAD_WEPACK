//
//  ItineraryActivity.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import Foundation

enum ActivityType: String, Codable, CaseIterable {
    case transport = "Transport"
    case food = "Food"
    case lodging = "Lodging"
    case leisure = "Leisure"
    case attraction = "Attraction"
    
    var iconName: String {
        switch self {
        case .transport: return "airplane"
        case .food: return "fork.knife"
        case .lodging: return "bed.double.fill"
        case .leisure: return "beach.umbrella.fill"
        case .attraction: return "ticket.fill"
        }
    }
}

struct ItineraryActivity: Identifiable, Codable {
    var id: String
    var tripId: String
    var name: String
    var startTime: Date      // 1. Diubah dari 'time' menjadi 'startTime'
    var endTime: Date?       // 2. Ditambahkan 'endTime' opsional (pakai tanda tanya ?)
    var location: String
    var type: ActivityType
    
    // Helper untuk memformat Start Time (Jam Mulai)
    var startTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: startTime)
    }
    
    // 3. Helper baru untuk memformat End Time (Jam Selesai) jika ada datanya
    var endTimeString: String? {
        guard let endTime = endTime else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: endTime)
    }
}
