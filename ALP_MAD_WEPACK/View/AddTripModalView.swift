//
//  AddTripModalView.swift
//  ALP_MAD_WEPACK
//
//  Created by MacintoshHD on 29/05/26.
//

import SwiftUI

struct AddTripModalView: View {
    @Environment(\.dismiss) var dismiss
    var viewModel: TripViewModel
    
    @State private var tripName = ""
    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Trip Information")) {
                    TextField("e.g. Graduation Trip Bali", text: $tripName)
                    TextField("e.g. Ubud, Bali", text: $destination)
                }
                
                Section(header: Text("Timeline")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        viewModel.createNewTrip(
                            name: tripName,
                            destination: destination,
                            start: startDate,
                            end: endDate
                        )
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}
