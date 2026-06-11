//
//  NotificationView.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//
//
import SwiftUI

struct NotificationView: View {
    @StateObject private var viewModel = NotificationViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color senada dengan TripListView
                Color(red: 0.96, green: 0.97, blue: 0.98)
                    .ignoresSafeArea()
                
                if viewModel.invitations.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No pending invitations")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.invitations) { invitation in
                                InvitationCardView(invitation: invitation, viewModel: viewModel)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                }
            }
        }
    }
}

// Sub-view untuk Card Undangan
struct InvitationCardView: View {
    let invitation: Invitation
    @ObservedObject var viewModel: NotificationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(invitation.senderName.prefix(1)).uppercased())
                            .font(.headline)
                            .foregroundColor(.black)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("**\(invitation.senderName)** invited you to join")
                        .font(.subheadline)
                    Text(invitation.tripName)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                }
                Spacer()
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.declineInvitation(invitation: invitation)
                }) {
                    Text("Decline")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Button(action: {
                    viewModel.acceptInvitation(invitation: invitation)
                }) {
                    Text("Accept")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.08, green: 0.15, blue: 0.25))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    NotificationView()
}
