//
//  TripMember.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import Foundation

struct TripMember: Identifiable {
    var id: String              // UID User
    var name: String
    var role: String            // "Owner" atau "Member"
    var packingProgress: Double // Progress koper dia sendiri (0.0 - 1.0)
}

