//
//  AddPackingItemView.swift
//  ALP_MAD_WEPACK
//
//  Created by Anastasia on 29/05/26.
//

import SwiftUI

struct AddPackingItemView: View {
    @ObservedObject var viewModel: PackingViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var sizeClass

    // Di iPad: 3 kolom kategori, di iPhone: 2 kolom
    var categoryColumns: [GridItem] {
        sizeClass == .regular
            ? [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
            : [GridItem(.flexible()), GridItem(.flexible())]
    }

    var isFormValid: Bool {
        let isNameFilled = !viewModel.newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isCustomValid = viewModel.assignmentType == .custom ? !viewModel.selectedMemberIds.isEmpty : true
        return isNameFilled && isCustomValid
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // ITEM NAME
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ITEM NAME *")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)

                        TextField("E.g., Sunglasses, Sunscreen", text: $viewModel.newItemName)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }

                    // CATEGORY grid
                    VStack(alignment: .leading, spacing: 8) {
                        Text("CATEGORY *")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)

                        LazyVGrid(columns: categoryColumns, spacing: 12) {
                            ForEach(PackingCategory.allCases, id: \.self) { category in
                                let isSelected = viewModel.selectedCategory == category
                                HStack {
                                    Image(systemName: category.iconName)
                                    Text(category.rawValue)
                                        .fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(isSelected ? Color.blue.opacity(0.15) : Color(.secondarySystemBackground))
                                .foregroundColor(isSelected ? .blue : .primary)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    viewModel.selectedCategory = category
                                }
                            }
                        }
                    }

                    // WHO BRINGS THIS
                    VStack(alignment: .leading, spacing: 12) {
                        Text("WHO BRINGS THIS? *")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)

                        HStack(spacing: 0) {
                            Button(action: { viewModel.assignmentType = .everyone }) {
                                Text("Everyone")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(viewModel.assignmentType == .everyone ? Color.white : Color.clear)
                                    .foregroundColor(viewModel.assignmentType == .everyone ? .black : .gray)
                                    .fontWeight(viewModel.assignmentType == .everyone ? .bold : .regular)
                            }
                            .cornerRadius(8)
                            .shadow(color: viewModel.assignmentType == .everyone ? .black.opacity(0.05) : .clear, radius: 2)

                            Button(action: { viewModel.assignmentType = .custom }) {
                                Text("Custom")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(viewModel.assignmentType == .custom ? Color.white : Color.clear)
                                    .foregroundColor(viewModel.assignmentType == .custom ? .black : .gray)
                                    .fontWeight(viewModel.assignmentType == .custom ? .bold : .regular)
                            }
                            .cornerRadius(8)
                            .shadow(color: viewModel.assignmentType == .custom ? .black.opacity(0.05) : .clear, radius: 2)
                        }
                        .padding(4)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }

                    // SELECT MEMBERS (hanya muncul kalau Custom)
                    if viewModel.assignmentType == .custom {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SELECT MEMBERS")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)

                            // Di iPad tampilkan lebih banyak member per baris
                            let memberColumns: [GridItem] = sizeClass == .regular
                                ? Array(repeating: GridItem(.flexible()), count: min(viewModel.tripMembers.count, 5))
                                : []

                            if sizeClass == .regular {
                                LazyVGrid(columns: memberColumns, spacing: 16) {
                                    ForEach(viewModel.tripMembers) { member in
                                        memberAvatar(member: member)
                                    }
                                }
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(viewModel.tripMembers) { member in
                                            memberAvatar(member: member)
                                        }
                                    }
                                    .padding(.horizontal, 4)
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding()
                // Di iPad, batasi lebar form
                .frame(maxWidth: sizeClass == .regular ? 600 : .infinity)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Add New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewModel.resetForm()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Item") {
                        viewModel.saveNewItem()
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(!isFormValid)
                }
            }
        }
    }

    // Avatar member yang bisa di-tap
    @ViewBuilder
    private func memberAvatar(member: TripMember) -> some View {
        let isSelected = viewModel.selectedMemberIds.contains(member.id)

        VStack(spacing: 6) {
            ZStack(alignment: .topTrailing) {
                Text(viewModel.getInisial(for: member.id))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 55, height: 55)
                    .background(viewModel.getBadgeColor(for: [member.id]))
                    .clipShape(Circle())

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.teal)
                        .background(Color.white.clipShape(Circle()))
                        .font(.title3)
                        .offset(x: 4, y: -4)
                }
            }

            Text(member.name.replacingOccurrences(of: " (You)", with: ""))
                .font(.caption)
                .foregroundColor(.primary)
        }
        .onTapGesture {
            viewModel.toggleMemberSelection(id: member.id)
        }
    }
}

#Preview {
    AddPackingItemView(viewModel: PackingViewModel(trip: Trip(id: "PREVIEW", name: "Preview", destination: "Bali", startDate: Date(), endDate: Date(), ownerId: "me", memberIds: ["me"], groupProgress: 0.0)))
}
