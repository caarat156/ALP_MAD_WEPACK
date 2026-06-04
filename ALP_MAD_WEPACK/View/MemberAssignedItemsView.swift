//
//  MemberAssignedItemsView.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//
import SwiftUI

struct MemberAssignedItemsView: View {
    let member: MemberProgressUI
    @Environment(\.presentationMode) var presentationMode
    
    @State private var assignedItems: [PackingItem] = []
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Text(member.initials)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(member.themeColor))
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(member.name).font(.title3.bold())
                        if member.isYou {
                            Text("YOU")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.teal)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.teal.opacity(0.15))
                                .cornerRadius(6)
                        }
                    }
                    Text("\(assignedItems.filter { $0.isPacked }.count) of \(assignedItems.count) items packed")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.5))
                }
            }
            .padding()
            .background(Color.white)
            
            Divider()
            
            if assignedItems.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "shippingbox.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.3))
                    Text("No items assigned.")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 248/255, green: 249/255, blue: 251/255))
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(assignedItems, id: \.id) { item in
                            
                            Button(action: {
                                if let targetIndex = assignedItems.firstIndex(where: { $0.id == item.id }) {
                                    withAnimation {
                                        assignedItems[targetIndex].isPacked.toggle()
                                    }
                                }
                            }) {
                                HStack(spacing: 16) {
                                    Image(systemName: item.isPacked ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .foregroundColor(item.isPacked ? member.themeColor : .gray.opacity(0.3))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.name)
                                            .font(.subheadline)
                                            .fontWeight(item.isPacked ? .regular : .semibold)
                                            .strikethrough(item.isPacked, color: .gray)
                                            .foregroundColor(item.isPacked ? .gray : .black)
                                        
                                        Text(item.assignedTo.contains("Everyone") ? "Shared Item" : "Personal Item")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(item.assignedTo.contains("Everyone") ? .orange : .blue)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(item.assignedTo.contains("Everyone") ? Color.orange.opacity(0.1) : Color.blue.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.03), radius: 3, x: 0, y: 2)
                            }
                            .disabled(!member.isYou)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                .background(Color(red: 248/255, green: 249/255, blue: 251/255))
            }
        }
        .onAppear {
            assignedItems = MockData.samplePackingItems.filter { item in
                item.assignedTo.contains("Everyone") || item.assignedTo.contains(member.id)
            }
        }
    }
}
