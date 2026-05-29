//
//  AddActivityModalView.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import SwiftUI

struct AddActivityModalView: View {
    @Environment(\.dismiss) var dismiss
    
    var viewModel: TripViewModel
    let trip: Trip // Menerima trip objek utuh
    @State var selectedDay: Int
    
    @State private var activityName: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var location: String = ""
    @State private var selectedType: ActivityType = .leisure
    
    var totalDaysCount: Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: trip.startDate)
        let end = calendar.startOfDay(for: trip.endDate)
        let components = calendar.dateComponents([.day], from: start, to: end)
        return (components.day ?? 0) + 1
    }
    
    func getSubDayName(for index: Int) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        if let targetDate = calendar.date(byAdding: .day, value: index, to: trip.startDate) {
            return formatter.string(from: targetDate)
        }
        return ""
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.98, green: 0.98, blue: 0.99).ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header Modal
                HStack {
                    Text("Add Activity")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.gray)
                            .frame(width: 32, height: 32)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24).padding(.top, 24)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        CustomInputView(label: "ACTIVITY NAME *", placeholder: "e.g. Sunset at Kuta Beach", text: $activityName)
                        
                        // Day Selector Pills Dinamis mengikuti input user
                        VStack(alignment: .leading, spacing: 8) {
                            Text("DAY *").font(.system(size: 11, weight: .bold)).foregroundColor(.gray)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(0..<max(1, totalDaysCount), id: \.self) { index in
                                        let dayNumber = index + 1
                                        DayPill(label: "Day \(dayNumber)", sub: getSubDayName(for: index), isSelected: selectedDay == dayNumber) {
                                            selectedDay = dayNumber
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Start & End Time
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("START TIME *").font(.system(size: 11, weight: .bold)).foregroundColor(.gray)
                                DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .frame(height: 50).frame(maxWidth: .infinity)
                                    .padding(.horizontal, 12).background(Color.white).cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text("END TIME").font(.system(size: 11, weight: .bold)).foregroundColor(.gray)
                                DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .frame(height: 50).frame(maxWidth: .infinity)
                                    .padding(.horizontal, 12).background(Color.white).cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                            }
                        }
                        
                        CustomInputView(label: "LOCATION *", placeholder: "e.g. Kuta Beach, Badung", text: $location)
                        
                        // Activity Type
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ACTIVITY TYPE *").font(.system(size: 11, weight: .bold)).foregroundColor(.gray)
                            HStack(spacing: 12) {
                                TypeButton(type: .transport, current: $selectedType)
                                TypeButton(type: .food, current: $selectedType)
                                TypeButton(type: .attraction, current: $selectedType)
                            }
                            HStack(spacing: 12) {
                                TypeButton(type: .leisure, current: $selectedType)
                                TypeButton(type: .lodging, current: $selectedType)
                                Spacer()
                            }
                        }
                        
                        // Save Button
                        Button(action: {
                            let calendar = Calendar.current
                            let daysToAdd = selectedDay - 1
                            let finalStartDate = calendar.date(byAdding: .day, value: daysToAdd, to: startTime) ?? startTime
                            let finalEndDate = calendar.date(byAdding: .day, value: daysToAdd, to: endTime) ?? endTime
                            
                            let newActivity = ItineraryActivity(
                                id: UUID().uuidString,
                                tripId: trip.id, // Menyimpan id trip secara otomatis
                                name: activityName,
                                startTime: finalStartDate,
                                endTime: finalEndDate,
                                location: location,
                                type: selectedType
                            )
                            
                            viewModel.addActivity(newActivity)
                            dismiss()
                        }) {
                            Text("Save Activity")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity).frame(height: 54)
                                .background(Color(red: 0.08, green: 0.15, blue: 0.25)).cornerRadius(16)
                        }
                        .padding(.top, 10)
                        .disabled(activityName.isEmpty || location.isEmpty)
                        .opacity(activityName.isEmpty || location.isEmpty ? 0.5 : 1.0)
                    }
                    .padding(.horizontal, 24).padding(.bottom, 30)
                }
            }
        }
    }
}

// 🔥 DEFINISI SUB-KOMPONEN FORM DI LUAR STRUCT UTAMA 🔥
struct CustomInputView: View {
    var label: String
    var placeholder: String
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.system(size: 11, weight: .bold)).foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .padding().frame(height: 50).background(Color.white).cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
        }
    }
}

struct DayPill: View {
    var label: String
    var sub: String
    var isSelected: Bool
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(label).font(.system(size: 14, weight: .bold))
                Text(sub).font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : Color(red: 0.08, green: 0.15, blue: 0.25))
            .padding(.horizontal, 16).padding(.vertical, 12)
            .background(isSelected ? Color(red: 0.08, green: 0.15, blue: 0.25) : Color.white).cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1))
        }
    }
}

struct TypeButton: View {
    var type: ActivityType
    @Binding var current: ActivityType
    var isSelected: Bool { current == type }
    var body: some View {
        Button(action: { current = type }) {
            VStack(spacing: 8) {
                Image(systemName: iconForType(type)).font(.system(size: 18))
                Text(labelForType(type)).font(.system(size: 11, weight: .bold))
            }
            .foregroundColor(Color(red: 0.08, green: 0.15, blue: 0.25))
            .frame(maxWidth: .infinity).frame(height: 68)
            .background(isSelected ? Color(red: 0.08, green: 0.15, blue: 0.25).opacity(0.05) : Color.white).cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color(red: 0.08, green: 0.15, blue: 0.25) : Color.gray.opacity(0.2), lineWidth: isSelected ? 1.5 : 1))
        }
    }
    private func iconForType(_ type: ActivityType) -> String {
        switch type {
        case .transport: return "airplane"
        case .food: return "fork.knife"
        case .attraction: return "figure.surfing"
        case .leisure: return "leaf"
        case .lodging: return "house"
        }
    }
    private func labelForType(_ type: ActivityType) -> String {
        switch type {
        case .transport: return "Transport"
        case .food: return "Food"
        case .attraction: return "Activity"
        case .leisure: return "Leisure"
        case .lodging: return "Accommodation"
        }
    }
}
