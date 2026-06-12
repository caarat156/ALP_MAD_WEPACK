//
//  PackingListView.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//
import SwiftUI

struct PackingListView: View {
    // 📢 Harus @ObservedObject biar bisa terima data dari MainTripView
    @ObservedObject var viewModel: PackingViewModel
    @Environment(\.horizontalSizeClass) var sizeClass
    
    // ❌ HAPUS INI: init(trip: Trip) { ... } (Hapus seluruh bagian init ini)
    
    var body: some View {
        VStack(spacing: 16) {
            // --- Custom Header ---
            HStack {
                Text("Packing List")
                    .font(.system(size: 28, weight: .bold))
                Spacer()
                Button(action: {
                    viewModel.showAddItemSheet.toggle()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                        Text("Add Item")
                    }
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(red: 0.08, green: 0.15, blue: 0.25))
                    .cornerRadius(20)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            
            // Progress header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(viewModel.packedCount) of \(viewModel.myItems.count) items packed")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(viewModel.progressPercentage)%")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                ProgressView(value: Double(viewModel.packedCount), total: Double(max(1, viewModel.myItems.count)))
                    .tint(.blue)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            // Di iPad, batasi lebar progress bar agar tidak melebar terlalu jauh
            .padding(.horizontal, sizeClass == .regular ? 40 : 16)
            .frame(maxWidth: sizeClass == .regular ? 700 : .infinity)
            .frame(maxWidth: .infinity)
            
            // List item
            List {
                ForEach(PackingCategory.allCases, id: \.self) { category in
                    let categoryItems = viewModel.packingItems.filter { $0.category == category }
                    
                    if !categoryItems.isEmpty {
                        Section(header: HStack {
                            Image(systemName: category.iconName)
                            Text(category.rawValue)
                        }) {
                            ForEach(categoryItems) { item in
                                HStack {
                                    let isPackedByMe = item.packedBy.contains(viewModel.currentUserId)
                                    Image(systemName: isPackedByMe ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(isPackedByMe ? .green : .gray)
                                        .font(.title3)
                                        .onTapGesture {
                                            viewModel.toggleItemPacked(item: item)
                                        }
                                    
                                    Text(item.name)
                                        .strikethrough(isPackedByMe)
                                        .foregroundColor(isPackedByMe ? .secondary : .primary)
                                    
                                    Spacer()
                                    
                                    Text(viewModel.getMemberName(for: item.assignedTo))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(viewModel.getBadgeColor(for: item.assignedTo))
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                }
            }
            // Di iPad pakai insetGrouped lebih nyaman, di iPhone sama
            .listStyle(.insetGrouped)
        }
        .sheet(isPresented: $viewModel.showAddItemSheet) {
            AddPackingItemView(viewModel: viewModel)
                .presentationDetents([.large])
        }
    }
}
