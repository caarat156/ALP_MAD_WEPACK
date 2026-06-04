//
//  AddMemberView.swift
//  ALP_MAD_WEPACK
//
//  Created by student on 29/05/26.
//

import SwiftUI


struct AddMemberView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = AddMemberViewModel()
    
    let darkBlue = Color(red: 37/255, green: 45/255, blue: 67/255)
    let lightGrayBg = Color(red: 247/255, green: 248/255, blue: 250/255)
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Text("Add Member")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(10)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.tripName)
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("\(viewModel.tripDate) • \(viewModel.members.count) members")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(lightGrayBg)
                    .cornerRadius(16)
                    .padding(.top, 16)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("INVITE VIA")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 12) {
                            Button(action: { viewModel.inviteMethod = 0 }) {
                                HStack {
                                    Image(systemName: "at")
                                    Text("Username")
                                }
                                .font(.subheadline.bold())
                                .foregroundColor(viewModel.inviteMethod == 0 ? darkBlue : .gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(viewModel.inviteMethod == 0 ? Color.blue.opacity(0.05) : Color.clear)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(viewModel.inviteMethod == 0 ? darkBlue : Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                            
                            Button(action: { viewModel.inviteMethod = 1 }) {
                                HStack {
                                    Image(systemName: "envelope")
                                    Text("Email")
                                }
                                .font(.subheadline.bold())
                                .foregroundColor(viewModel.inviteMethod == 1 ? darkBlue : .gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(viewModel.inviteMethod == 1 ? Color.blue.opacity(0.05) : Color.clear)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(viewModel.inviteMethod == 1 ? darkBlue : Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.inviteMethod == 0 ? "USERNAME *" : "EMAIL *")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Image(systemName: viewModel.inviteMethod == 0 ? "at" : "envelope")
                                .foregroundColor(darkBlue)
                            TextField(viewModel.inviteMethod == 0 ? "username" : "example@email.com", text: $viewModel.inviteInput)
                                .font(.body)
                                .keyboardType(viewModel.inviteMethod == 1 ? .emailAddress : .default)
                                .autocapitalization(.none)
                        }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        
                        Text("The person will receive a join request they can accept or decline.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    HStack(spacing: 12) {
                        Button(action: {
                            viewModel.resetForm() 
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                                .font(.subheadline.bold())
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        }
                        
                        Button(action: {
                            viewModel.sendRequest()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Send Request")
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(darkBlue)
                                .cornerRadius(16)
                        }
                        .disabled(viewModel.inviteInput.isEmpty)
                    }
                    .padding(.vertical, 8)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("CURRENT MEMBERS")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        
                        ForEach(viewModel.members) { member in
                            HStack {
                                Text(member.initials)
                                    .font(.subheadline.bold())
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Circle().fill(member.isYou ? darkBlue : Color(red: 90/255, green: 140/255, blue: 160/255)))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(member.name)
                                        .font(.subheadline.bold())
                                    Text(member.username)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                if member.isYou {
                                    Text("YOU")
                                        .font(.caption2.bold())
                                        .foregroundColor(darkBlue)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(20)
                                } else {
                                    Button(action: {
                                        withAnimation {
                                            viewModel.removeMember(id: member.id)
                                        }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .padding(10)
                                            .background(Color.red.opacity(0.1))
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .padding()
                            .background(lightGrayBg)
                            .cornerRadius(12)
                        }
                    }
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
}
#Preview {
    AddMemberView()
}
