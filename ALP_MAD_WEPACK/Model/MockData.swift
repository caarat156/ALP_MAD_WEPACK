//
//  MockData.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import Foundation

struct MockData {
    
    // --- Helper untuk membuat tanggal dummy secara dinamis ---
    static func createDate(daysAhead: Int, hour: Int = 0, minute: Int = 0) -> Date {
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: .day, value: daysAhead, to: Date()) else { return Date() }
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date) ?? Date()
    }
    
    // ==========================================
    // 1. DUMMY USER PROFILE (Porsi Caca)
    // ==========================================
    static let sampleUser = UserProfile(
        id: "USER_CACA_123",
        name: "Caca Clarissa",
        email: "caca.clarissa@student.uc.ac.id",
        headline: "Travel Logistics Enthusiast ",
        avatarUrl: nil,
        totalTrips: 3,
        totalItemsPacked: 45
    )
    
    // ==========================================
    // 2. DUMMY TRIPS (Porsi Angel)
    // ==========================================
    static let sampleTrips: [Trip] = [
        Trip(
            id: "TRIP_BALI_2026",
            name: "Graduation Trip Bali ",
            destination: "Ubud & Seminyak, Bali",
            startDate: createDate(daysAhead: 14), // 2 minggu lagi
            endDate: createDate(daysAhead: 18),
            ownerId: "USER_CACA_123",
            memberIds: ["USER_CACA_123", "USER_ANGEL_456", "USER_NDUT_789"],
            groupProgress: 0.68 // 68%
        ),
        Trip(
            id: "TRIP_JOGJA_2026",
            name: "Yogyakarta Culinary Run ",
            destination: "Malioboro, Yogyakarta",
            startDate: createDate(daysAhead: 45),
            endDate: createDate(daysAhead: 48),
            ownerId: "USER_ANGEL_456",
            memberIds: ["USER_CACA_123", "USER_ANGEL_456"],
            groupProgress: 0.15 // 15%
        )
    ]
    
    // ==========================================
    // 3. DUMMY ITINERARIES (Porsi Angel)
    // ==========================================
    static let sampleActivities: [ItineraryActivity] = [
        // Day 1 Bali
        // Contoh penulisan di MockData kamu agar tidak error:
        ItineraryActivity(
            id: "1",
            tripId: "bali",
            name: "Arrival & Check-in",
            startTime: Date(),            // diubah jadi startTime
            endTime: Date().addingTimeInterval(3600), // diubah jadi endTime (opsional)
            location: "Kuta Villa",
            type: .lodging
        )
    ]
    
    // ==========================================
    // 4. DUMMY PACKING ITEMS (Porsi Caca)
    // ==========================================
    static let samplePackingItems: [PackingItem] = [
        // Kategori Clothing
        PackingItem(id: "ITEM_1", tripId: "TRIP_BALI_2026", name: "Beach Outfit (4 sets)", category: .clothing, isPacked: true, assignedTo: ["Everyone"]),
        PackingItem(id: "ITEM_2", tripId: "TRIP_BALI_2026", name: "Swimwear 🩱", category: .clothing, isPacked: false, assignedTo: ["Everyone"]),
        
        // Kategori Electronics
        PackingItem(id: "ITEM_3", tripId: "TRIP_BALI_2026", name: "MacBook & Charger", category: .electronics, isPacked: true, assignedTo: ["USER_CACA_123"]),
        PackingItem(id: "ITEM_4", tripId: "TRIP_BALI_2026", name: "Powerbank 20k mAh", category: .electronics, isPacked: false, assignedTo: ["USER_ANGEL_456"]),
        
        // Kategori Medical
        PackingItem(id: "ITEM_5", tripId: "TRIP_BALI_2026", name: "Tolakan Angin & Obat Pribadi", category: .medical, isPacked: true, assignedTo: ["Everyone"]),
        
        // Kategori Documents
        PackingItem(id: "ITEM_6", tripId: "TRIP_BALI_2026", name: "KTP & Tiket Pesawat di Apple Wallet", category: .documents, isPacked: true, assignedTo: ["Everyone"])
    ]
    
    // ==========================================
    // 5. DUMMY TRIP MEMBERS STATUS (Porsi Ndut)
    // ==========================================
    static let sampleTripMembers: [TripMember] = [
        TripMember(id: "USER_CACA_123", name: "Caca (You)", role: "Trip Leader", packingProgress: 0.85), // Koper Caca udah 85% siap
        TripMember(id: "USER_ANGEL_456", name: "Angelique", role: "Member", packingProgress: 0.60),     // Koper Angel 60% siap
        TripMember(id: "USER_NDUT_789", name: "Ndut", role: "Member", packingProgress: 0.40)           // Koper Ndut 40% siap
    ]
}
