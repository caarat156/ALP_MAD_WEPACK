//
//  PackingItem.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import Foundation
enum PackingCategory: String, Codable, CaseIterable {
    case clothing = "Clothing"
    case electronics = "Electronics"
    case medical = "Medical"
    case documents = "Documents"
    case essentials = "Essentials"
    
    var iconName: String {
        switch self {
        case .clothing: return "tshirt.fill"
        case .electronics: return "powerplug.fill"
        case .medical: return "cross.case.fill"
        case .documents: return "doc.plaintext.fill"
        case .essentials: return "sparkles"
        }
    }
}
struct PackingItem: Identifiable, Codable {
    var id: String
    var tripId: String
    var name: String
    var category: PackingCategory
    var isPacked: Bool
    var assignedTo: [String]
}
