//
//  ItineraryListView.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import SwiftUI

struct ItineraryView: View {
    var tripViewModel: TripViewModel
    var activityViewModel: ActivityViewModel
    let trip: Trip
    
    @State private var selectedDay: Int = 1
    @State private var isShowingAddActivity = false
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var totalDaysCount: Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: trip.startDate)
        let end = calendar.startOfDay(for: trip.endDate)
        let components = calendar.dateComponents([.day], from: start, to: end)
        return (components.day ?? 0) + 1
    }
    
    var dynamicDays: [String] {
        (1...max(1, totalDaysCount)).map { "Day \($0)" }
    }
    
    var dynamicSubDays: [String] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return (0..<max(1, totalDaysCount)).map { index in
            if let dateForDay = calendar.date(byAdding: .day, value: index, to: trip.startDate) {
                return formatter.string(from: dateForDay)
            }
            return ""
        }
    }
    
    func formatDateForSelectedDay() -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        if let targetDate = calendar.date(byAdding: .day, value: selectedDay - 1, to: trip.startDate) {
            return formatter.string(from: targetDate)
        }
        return ""
    }
    
    var filteredActivities: [ItineraryActivity] {
        // 📢 1. PERBAIKAN DI SINI: pakai activityViewModel
        activityViewModel.activities.filter { activity in
            let isCurrentTrip = activity.tripId == trip.id
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: trip.startDate), to: calendar.startOfDay(for: activity.startTime))
            let activityDay = (components.day ?? 0) + 1
            return isCurrentTrip && activityDay == selectedDay
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.97, green: 0.98, blue: 0.99).ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                HStack {
                    Spacer()
                    VStack(spacing: 2) {
                        Text("🌴 \(trip.name)").font(.system(size: 16, weight: .bold))
                        Text("\(trip.destination)").font(.system(size: 11)).foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding().background(Color.white)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Itinerary").font(.system(size: 28, weight: .black))
                                Text("\(trip.name) · \(totalDaysCount) days").font(.subheadline).foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: { isShowingAddActivity = true }) {
                                Text("+ Add Activity").font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white).padding(.horizontal, 16).padding(.vertical, 10)
                                    .background(Color(red: 0.08, green: 0.15, blue: 0.25)).cornerRadius(20)
                            }
                        }
                        .padding(.horizontal, 20).padding(.top, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(0..<dynamicDays.count, id: \.self) { index in
                                    DayButton(dayText: dynamicDays[index], subText: dynamicSubDays[index], isSelected: selectedDay == index + 1) {
                                        selectedDay = index + 1
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        HStack {
                            Text("Day \(selectedDay) — \(formatDateForSelectedDay())")
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                        }.padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            ForEach(filteredActivities) { activity in
                                ItineraryCardView(activity: activity)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(maxWidth: sizeClass == .compact ? .infinity : 700)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .sheet(isPresented: $isShowingAddActivity) {
            AddActivityModalView(activityviewModel: activityViewModel, trip: trip, selectedDay: selectedDay)
        }
    }
}


struct DayButton: View {
    let dayText: String
    let subText: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayText).font(.system(size: 16, weight: .bold))
                Text(subText).font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : Color(red: 0.08, green: 0.15, blue: 0.25).opacity(0.6))
            .frame(width: 80, height: 75)
            .background(isSelected ? Color(red: 0.08, green: 0.15, blue: 0.25) : Color.white)
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleTrip = Trip(
        id: "PREVIEW_ID",
        name: "Preview Bali",
        destination: "Bali",
        startDate: Date(),
        endDate: Date().addingTimeInterval(86400 * 3),
        ownerId: "me",
        memberIds: ["me"],
        groupProgress: 0.5,
        
    )
    
    ItineraryView(
        tripViewModel: TripViewModel(),
        activityViewModel: ActivityViewModel(),
        trip: sampleTrip
    )
}
