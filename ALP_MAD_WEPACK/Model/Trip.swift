//
//  Trip.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import Foundation
import UIKit // 📢 Diperlukan untuk menggunakan UIImage

struct Trip: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var ownerId: String
    var memberIds: [String]
    var groupProgress: Double
    
    // 📢 Menyimpan gambar kustom yang di-input oleh user sendiri
    var customImage: Data?

    var dateRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
}
