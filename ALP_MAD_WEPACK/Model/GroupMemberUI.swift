//
//  GroupMemberUI.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//

import Foundation

// Struct bantuan khusus untuk UI Halaman Add Member
struct GroupMemberUI: Identifiable {
    let id: String
    let name: String
    let username: String
    let initials: String
    let isYou: Bool
}
