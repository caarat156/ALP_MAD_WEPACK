//
//  MemberPageView.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct MemberPageView: View {
    // Mengambil data dari MockData
    let trip = MockData.sampleTrips[0] // Ambil trip pertama (Bali)
    let members = MockData.sampleTripMembers
    
    @State private var showAddMember = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // --- 1. GROUP READINESS CARD ---
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Group Readiness")
                                .font(.headline)
                            Text("\(members.count) members • synced live")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // Circular Progress Indicator
                        HStack(alignment: .bottom, spacing: 4) {
                            Text("\(Int(trip.groupProgress * 100))%")
                                .font(.system(size: 36, weight: .bold))
                            
                            // Visualisasi Cincin Progress Kecil
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 6)
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(trip.groupProgress))
                                    .stroke(Color.teal, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                            }
                            .frame(width: 30, height: 30)
                            .padding(.bottom, 6)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // --- 2. MEMBER GRID ---
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(members) { member in
                            VStack(spacing: 12) {
                                // Avatar Inisial
                                Text(String(member.name.prefix(1)).uppercased())
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(Circle().fill(Color.indigo))
                                
                                VStack(spacing: 2) {
                                    Text(member.name)
                                        .font(.headline)
                                    Text(member.role)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                // Progress Bar
                                VStack(spacing: 4) {
                                    ProgressView(value: member.packingProgress)
                                        .progressViewStyle(LinearProgressViewStyle(tint: member.packingProgress > 0.7 ? .green : .orange))
                                    
                                    Text("\(Int(member.packingProgress * 100))% Ready")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 4)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Members")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddMember = true }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Member")
                        }
                        .font(.subheadline.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                }
            }
            // Memunculkan Sheet Add Member
            .sheet(isPresented: $showAddMember) {
                AddMemberView()
            }
        }
    }
}
