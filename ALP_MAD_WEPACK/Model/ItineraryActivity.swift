//
//  ItineraryActivity.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import Foundation

// 1. PASTIKAN ENUM KAMU ADA ": String, Codable" NYA!
enum ActivityType: String, Codable {
    case transport
    case food
    case attraction
    case leisure
    
    // Properti pembantu untuk ikon jam tangan
    var iconName: String {
        switch self {
        case .transport: return "car.fill"
        case .food: return "fork.knife"
        case .attraction: return "mappin.and.ellipse"
        case .leisure: return "sparkles"
        }
    }
}

// 2. PASTIKAN STRUCT UTAMA SEPERTI INI
struct ItineraryActivity: Identifiable, Codable {
    let id: String
    let tripId: String
    let name: String
    let startTime: Date
    let endTime: Date
    let location: String
    let type: ActivityType // Ini enum yang di atas tadi
    
    // Helper string untuk jam aktivitas kamu
    var startTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: startTime)
    }
}
