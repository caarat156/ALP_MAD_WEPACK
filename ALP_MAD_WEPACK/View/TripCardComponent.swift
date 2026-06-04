//
//  TripCardComponent.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import SwiftUI

struct TripCardComponent: View {
    let trip: Trip
    var viewModel: TripViewModel
   
    @Environment(\.horizontalSizeClass) var sizeClass

    private var tripDateRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let startString = formatter.string(from: trip.startDate)
        let endString = formatter.string(from: trip.endDate)
        return "\(startString) — \(endString)"
    }
    
    var body: some View {
        VStack(spacing: 0) {

            ZStack(alignment: .bottomLeading) {
     
                if let data = trip.customImage, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 155)
                        .clipped()
                } else {
                    Image("bali_cover")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 155)
                        .clipped()
                }
        
                LinearGradient(
                    colors: [Color.black.opacity(0.3), Color.black.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack {
                    HStack {
                        Text(trip.ownerId == viewModel.currentUserID ? "Owner" : "Member")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(10)
                        
                        Spacer()
                        
                        Text("Upcoming")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.28))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                    }
                    .padding(12)
                    
                    Spacer()
                }
                HStack(spacing: 6) {
                    Text(trip.destination.lowercased().contains("bali") ? "🌴" : "🏛️")
                        .font(.system(size: 16))
                    
                    Text(trip.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .padding(16)
            }
            .frame(height: 155)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 16, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 16))
            
            VStack(spacing: 12) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.gray.opacity(0.7))
                            .font(.system(size: 13))
                        Text(trip.destination)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray.opacity(0.7))
                            .font(.system(size: 13))
                        Text(tripDateRangeString)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 4)
                HStack(spacing: 10) {
                    HStack(spacing: 6) {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.gray.opacity(0.7))
                            .font(.system(size: 13))
                        Text("\(trip.memberIds.count) members")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 95, alignment: .leading)
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.gray.opacity(0.12))
                            Capsule().fill(Color(red: 0.15, green: 0.32, blue: 0.48))
                                .frame(width: geo.size.width * CGFloat(trip.groupProgress))
                        }
                    }
                    .frame(height: 6)
                    
                    Text("\(Int(trip.groupProgress * 100))%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.28))
                        .frame(width: 32, alignment: .trailing)
                    
                    // Sisa Hari Dinamis
                    Text("\(viewModel.calculateDaysAway(from: trip.startDate))d away")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(red: 0.18, green: 0.36, blue: 0.56))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.18, green: 0.36, blue: 0.56).opacity(0.08))
                        .cornerRadius(6)
                }
                
                HStack {
                    Text("Open Trip")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.28))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.28))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(Color(red: 0.95, green: 0.96, blue: 0.98))
                .cornerRadius(12)
                .padding(.top, 4)
            }
            .padding(16)
            .background(Color.white)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 16, bottomTrailingRadius: 16, topTrailingRadius: 0))
        }
  
        .padding(.horizontal, sizeClass == .compact ? 20 : 0)
        .padding(.vertical, 4)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}
