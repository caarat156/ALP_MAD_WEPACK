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
    var time: Date
    var location: String
    var type: ActivityType
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
}
