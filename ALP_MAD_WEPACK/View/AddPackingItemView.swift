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
    
    let categoryColumns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var isFormValid: Bool {
        let isNameFilled = !viewModel.newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isCustomValid = viewModel.assignmentType == .custom ? !viewModel.selectedMemberIds.isEmpty : true
        return isNameFilled && isCustomValid
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
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
                    
                    if viewModel.assignmentType == .custom {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SELECT MEMBERS")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 20) {
                                ForEach(MockData.sampleTripMembers) { member in
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
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding()
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
}

#Preview {
    AddPackingItemView(viewModel: PackingViewModel())
}
