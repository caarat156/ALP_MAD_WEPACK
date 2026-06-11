//
//  Trip.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import Foundation

struct Trip: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var ownerId: String
    var memberIds: [String]
    var groupProgress: Double

    var dateRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
    
    var durationInDays: Int {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: startDate), to: calendar.startOfDay(for: endDate))
            return (components.day ?? 0) + 1
        }
    }

//import Foundation
//
//struct Trip: Codable, Identifiable {
//    let id: String
//    let name: String
//    let destination: String
//    let startDate: Date
//    let endDate: Date
//    let ownerId: String
//    
//    // UBAH INI: Dari [String] jadi [TripMember]
//    var members: [TripMember]
//    
//    var groupProgress: Double
//}
//
//struct TripMember: Codable, Identifiable {
//    var id: String { uid } // Biar gampang dipake di SwiftUI List
//    let uid: String
//    var status: MemberStatus
//}
//
//enum MemberStatus: String, Codable {
//    case pending
//    case accepted
//}
