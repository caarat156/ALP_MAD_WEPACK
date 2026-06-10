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
}
