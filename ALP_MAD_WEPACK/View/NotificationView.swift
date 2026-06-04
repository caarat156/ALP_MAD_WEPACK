//
//  NotificationView.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct NotificationItem: Identifiable {
    let id = UUID()
    let inviter: String
    let username: String
    let tripName: String
    let time: String
}

struct NotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var pendingRequests = [
        NotificationItem(inviter: "Siti Rahayu", username: "@sitirahayu", tripName: "Yogyakarta Weekend Trip", time: "2 hours ago"),
        NotificationItem(inviter: "Arif Budiman", username: "@arifbudiman", tripName: "Lombok Backpacking", time: "Yesterday")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Notifications")
                    .font(.title2.bold())
                Spacer()
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
            }
            .padding()
            
            Divider()
            
            if pendingRequests.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.4))
                    Text("All caught up!")
                        .font(.headline)
                    Text("No pending trip requests right now.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.gray)
                            Text("Trip Join Requests")
                                .font(.headline)
                            Spacer()
                            Text("\(pendingRequests.count) pending")
                                .font(.caption.bold())
                                .foregroundColor(.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        
                        ForEach(pendingRequests) { request in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .top) {
                                    Text(String(request.inviter.prefix(2)).uppercased())
                                        .font(.subheadline.bold())
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Circle().fill(Color.teal))
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(request.inviter).font(.subheadline.bold())
                                        Text("Invited you to join a trip").font(.caption)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(request.time)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                
                                HStack {
                                    Image(systemName: "map.fill")
                                        .foregroundColor(.orange)
                                    Text(request.tripName)
                                        .font(.subheadline.bold())
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                
                                HStack(spacing: 12) {
                                    Button(action: { removeRequest(id: request.id) }) {
                                        Text("Decline")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4), lineWidth: 1))
                                    }
                                    
                                    Button(action: { removeRequest(id: request.id) }) {
                                        Text("Accept")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(Color.black) 
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
    private func removeRequest(id: UUID) {
        withAnimation {
            pendingRequests.removeAll { $0.id == id }
        }
    }
}
