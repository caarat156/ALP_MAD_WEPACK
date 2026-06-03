//
//  PackingListView.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import SwiftUI

struct PackingListView: View {
    // Inisialisasi si otak/ViewModel
    @StateObject private var viewModel = PackingViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // --- KOTAK PROGRESS ATAS ---
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(viewModel.packedCount) of \(viewModel.packingItems.count) items packed")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(viewModel.progressPercentage)%")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    ProgressView(value: Double(viewModel.packedCount), total: Double(max(1, viewModel.packingItems.count)))
                        .tint(.blue)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // --- LIST BARANG ---
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
                                        // PURE UI: Klik checkbox langsung lapor ke ViewModel
                                        Image(systemName: item.isPacked ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(item.isPacked ? .green : .gray)
                                            .font(.title3)
                                            .onTapGesture {
                                                viewModel.toggleItemPacked(item: item)
                                            }
                                        
                                        Text(item.name)
                                            .strikethrough(item.isPacked)
                                            .foregroundColor(item.isPacked ? .secondary : .primary)
                                        
                                        Spacer()
                                        
                                        // PURE UI: Warna dan nama text diambil dari ViewModel
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
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Packing List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showAddItemSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    }
                }
            }
            // Munculkan sheet dan pinjamkan viewModel yang sama ke halaman input
            .sheet(isPresented: $viewModel.showAddItemSheet) {
                AddPackingItemView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    PackingListView()
}
