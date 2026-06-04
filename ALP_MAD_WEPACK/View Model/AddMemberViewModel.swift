//
//  AddMemberViewModel.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//
import SwiftUI
import Combine

class AddMemberViewModel: ObservableObject {
    @Published var inviteMethod = 0 
    @Published var inviteInput = ""
    @Published var members: [GroupMemberUI] = []
    @Published var tripName: String = "Bali Group Adventure"
    @Published var tripDate: String = "Jun 14–17, 2026"
    
    init() {
        let currentUser = GroupMemberUI(
            id: "USER_CURRENT",
            name: "Rafi",
            username: "@rafi",
            initials: "RF",
            isYou: true
        )
        self.members = [currentUser]
    }
    
    func removeMember(id: String) {
        members.removeAll { $0.id == id }
    }
    
    func sendRequest() {
        var extractedName = ""
        var newUsername = ""
        
        if inviteMethod == 1 {
            let emailParts = inviteInput.components(separatedBy: "@")
            extractedName = emailParts.first?.capitalized ?? "New User"
            newUsername = "@\(extractedName.lowercased())"
        } else {
            let cleanInput = inviteInput.replacingOccurrences(of: "@", with: "")
            extractedName = cleanInput.capitalized
            newUsername = "@\(cleanInput.lowercased())"
        }
        
        let generatedInitials = String(extractedName.prefix(2)).uppercased()
        
        let newMember = GroupMemberUI(
            id: UUID().uuidString,
            name: extractedName,
            username: newUsername,
            initials: generatedInitials,
            isYou: false
        )
        
        withAnimation {
            members.append(newMember)
        }
        
        inviteInput = ""
    }
    
    func resetForm() {
        inviteInput = ""
    }
}
