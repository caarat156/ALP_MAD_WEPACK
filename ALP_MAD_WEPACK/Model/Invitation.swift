//
//  Invitation.swift
//  ALP_MAD_WEPACK
//
//  Created by Angelique Kyra on 12/06/26.
//

import Foundation
import FirebaseFirestore

struct Invitation: Identifiable, Codable {
    @DocumentID var id: String?
    let tripId: String
    let tripName: String
    let senderId: String
    let senderName: String
    let receiverId: String
    let status: InvitationStatus
    @ServerTimestamp var timestamp: Date?
    
    enum InvitationStatus: String, Codable {
        case pending, accepted, declined
    }
}
