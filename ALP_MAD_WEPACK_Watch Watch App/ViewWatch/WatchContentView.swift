//
//  WatchContentView.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct WatchContentView: View {
    @StateObject private var viewModel = WatchViewModel()
    
    // Warna tema khusus Watch
    let cardBackground = Color(white: 0.15) // Abu-abu gelap ala watchOS
    let accentTeal = Color(red: 120/255, green: 190/255, blue: 190/255)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                
                // --- 1. HEADER LOGO ---
                Text("WEPACK")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(accentTeal)
                    .tracking(2) // Memberi jarak antar huruf
                    .padding(.top, 4)
                
                // --- 2. UP NEXT CARD ---
                VStack(alignment: .leading, spacing: 6) {
                    Text("UP NEXT")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.gray)
                    
                    if let activity = viewModel.nextActivity {
                        HStack(alignment: .center, spacing: 6) {
                            Text(viewModel.getEmoji(for: activity.type))
                            Text(activity.name)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        
                        Text("\(viewModel.formatTime(date: activity.startTime)) • \(activity.location)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBackground)
                .cornerRadius(12)
                
                // --- 3. MY PACKING CARD ---
                VStack(alignment: .leading, spacing: 12) {
                    Text("MY PACKING")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.packingItems, id: \.id) { item in
                            Button(action: {
                                withAnimation {
                                    viewModel.toggleItem(id: item.id ?? "")
                                }
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: item.isPacked ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 18))
                                        .foregroundColor(item.isPacked ? accentTeal : .gray.opacity(0.5))
                                    
                                    Text(item.name)
                                        .font(.system(size: 14))
                                        .fontWeight(item.isPacked ? .regular : .medium)
                                        .strikethrough(item.isPacked, color: .gray)
                                        .foregroundColor(item.isPacked ? .gray : .white)
                                        .lineLimit(1)
                                    
                                    Spacer()
                                }
                            }
                            .buttonStyle(PlainButtonStyle()) // Agar tombol tidak memblokir seluruh area dengan warna abu-abu klik
                        }
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBackground)
                .cornerRadius(12)
                
                // --- 4. GROUP READY PROGRESS ---
                VStack(spacing: 6) {
                    HStack {
                        Text("Group Ready")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(Int(viewModel.groupReadiness * 100))%")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(accentTeal)
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color(white: 0.25))
                            Capsule()
                                .fill(accentTeal)
                                .frame(width: geo.size.width * CGFloat(viewModel.groupReadiness))
                        }
                    }
                    .frame(height: 4)
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 20)
                
            }
            .padding(.horizontal, 8)
        }
    }
}
