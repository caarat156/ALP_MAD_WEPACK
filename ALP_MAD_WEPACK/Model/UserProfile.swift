//
//  UserProfile.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import Foundation

struct UserProfile: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var headline: String
    var avatarUrl: String?
    
    var totalTrips: Int
    var totalItemsPacked: Int
}
