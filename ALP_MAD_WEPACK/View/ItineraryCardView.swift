//
//  ItineraryCardView.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import SwiftUI

struct ItineraryCardView: View {
    let activity: ItineraryActivity
    
    private var categoryColor: Color {
        switch activity.type {
        case .transport: return Color.blue.opacity(0.7)
        case .food: return Color.orange.opacity(0.7)
        case .lodging: return Color.cyan.opacity(0.7)
        case .leisure: return Color.green.opacity(0.7)
        case .attraction: return Color.purple.opacity(0.7)
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
         
            VStack(spacing: 0) {
                Text(activity.startTimeString)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25).opacity(0.7))
                    .frame(width: 50, alignment: .trailing)
                    .padding(.trailing, 16)
                    .padding(.bottom, 8)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.12))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }

            Circle()
                .fill(categoryColor)
                .frame(width: 12, height: 12)
                .padding(.top, 4)
                .padding(.trailing, 16)

            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 14) {
                    Image(systemName: activity.type.iconName)
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.08))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(activity.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                        
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 10))
                            Text(activity.location)
                                .font(.system(size: 12, weight: .medium))
                                .lineLimit(1)
                        }
                        .foregroundColor(.gray.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Text(activity.type.rawValue)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25).opacity(0.7))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                
                if let endTimeString = activity.endTimeString {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text("until \(endTimeString)")
                    }
                    .foregroundColor(.gray.opacity(0.8))
                    .padding(.leading, 64)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.025), radius: 10, x: 0, y: 5)
            .padding(.bottom, 20)
        }
    }
}
#Preview {
    ZStack {
        Color(red: 0.97, green: 0.98, blue: 0.99).ignoresSafeArea()
        ItineraryCardView(activity: ItineraryActivity(
            id: "1",
            tripId: "trip1",
            name: "Brunch at Cafe",
            location: "Seminyak",
            type: .food,
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600)
        ))
        .padding()
    }
}
