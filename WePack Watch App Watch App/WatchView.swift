//
//  WatchView.swift
//  ALP_MAD_WEPACK
//
//  Created by Angelique Kyra on 12/06/26.
//

import SwiftUI

struct WatchView: View {
    @StateObject var packingViewModel: PackingViewModel
    @StateObject var activityViewModel: ActivityViewModel
    
    // Inisialisasi ViewModel dengan data Trip
    init(trip: Trip) {
        _packingViewModel = StateObject(wrappedValue: PackingViewModel(trip: trip))
        _activityViewModel = StateObject(wrappedValue: ActivityViewModel())
    }
    
    var body: some View {
        TabView {
            // Halaman 1: Checklist Barang
            WatchPackingView(viewModel: packingViewModel)
                .tabItem {
                    Image(systemName: "suitcase.fill")
                    Text("Packing")
                }
            
            // Halaman 2: Aktivitas Selanjutnya
            WatchNextActivityView(viewModel: activityViewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Activity")
                }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

// MARK: - Sub-View untuk Packing
struct WatchPackingView: View {
    @ObservedObject var viewModel: PackingViewModel
    
    var myItems: [PackingItem] {
        viewModel.packingItems.filter { $0.assignedTo.contains("me") || $0.assignedTo.contains("Everyone") }
    }
    
    var packedCount: Int {
        myItems.filter { $0.isPacked }.count
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(packedCount)/\(myItems.count) Packed")
                    .font(.headline)
                    .foregroundColor(.teal)
                Spacer()
                ProgressView(value: Double(packedCount), total: Double(max(myItems.count, 1)))
                    .progressViewStyle(CircularProgressViewStyle(tint: .teal))
            }
            .padding(.horizontal)
            
            Divider()
            
            List(myItems) { item in
                Button(action: {
                    viewModel.toggleItemPacked(item: item)
                }) {
                    HStack {
                        Image(systemName: item.isPacked ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.isPacked ? .teal : .gray)
                        Text(item.name)
                            .strikethrough(item.isPacked)
                            .foregroundColor(item.isPacked ? .gray : .white)
                    }
                }
            }
        }
    }
}

// MARK: - Sub-View untuk Activity
struct WatchNextActivityView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var nextActivity: ItineraryActivity? {
        viewModel.activities.first { $0.startTime > Date() }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Up Next")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let activity = nextActivity {
                VStack(alignment: .leading, spacing: 6) {
                    Text(activity.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "clock")
                        Text(activity.startTime, style: .time)
                    }
                    .font(.subheadline)
                    .foregroundColor(.teal)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
            } else {
                Text("No upcoming activities!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
    }
}
