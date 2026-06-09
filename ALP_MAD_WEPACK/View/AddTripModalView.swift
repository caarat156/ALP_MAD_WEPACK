import SwiftUI
import PhotosUI

struct AddTripModalView: View {
    @Environment(\.dismiss) var dismiss
    var tripviewModel: TripViewModel
    
    @State private var tripName = ""
    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var tripType = "Leisure"
    @State private var description = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    let tripTypes = [
        ("Leisure", "beach.umbrella.fill", Color.orange),
        ("Adventure", "mountain.2.fill", Color.green),
        ("Family", "figure.2.and.child.holdinghands", Color.blue),
        ("Business", "briefcase.fill", Color.brown)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Add New Trip")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.3))
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color.gray.opacity(0.3))
                        }
                    }
                    .padding()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
   
                            CustomInputLabel(text: "TRIP COVER IMAGE *")
                            
                            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                                ZStack {
                                    if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 150)
                                            .cornerRadius(12)
                                            .clipped()
                                    } else {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(red: 0.96, green: 0.97, blue: 0.99))
                                            .frame(height: 150)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.blue.opacity(0.1), lineWidth: 1)
                                            )
                                        
                                        VStack(spacing: 8) {
                                            Image(systemName: "photo.on.rectangle.angled")
                                                .font(.system(size: 30))
                                                .foregroundColor(.gray)
                                            Text("Tap to upload trip cover image")
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                            .onChange(of: selectedItem) { oldItem, newItem in 
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                    }
                                }
                            }
                            
                            CustomInputLabel(text: "TRIP NAME *")
                            TextField("e.g. Bali Group Adventure", text: $tripName)
                                .modifier(FigmaInputStyle())
                            
                            CustomInputLabel(text: "DESTINATION *")
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.gray)
                                TextField("e.g. Bali, Indonesia", text: $destination)
                            }
                            .modifier(FigmaInputStyle())
                            
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 8) {
                                    CustomInputLabel(text: "START DATE *")
                                    DatePicker("", selection: $startDate, displayedComponents: .date)
                                        .labelsHidden()
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color(red: 0.96, green: 0.97, blue: 0.99))
                                        .cornerRadius(12)
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue.opacity(0.1), lineWidth: 1))
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    CustomInputLabel(text: "END DATE *")
                                    DatePicker("", selection: $endDate, displayedComponents: .date)
                                        .labelsHidden()
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color(red: 0.96, green: 0.97, blue: 0.99))
                                        .cornerRadius(12)
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue.opacity(0.1), lineWidth: 1))
                                }
                            }
                            
                            CustomInputLabel(text: "TRIP TYPE")
                            HStack(spacing: 12) {
                                ForEach(tripTypes, id: \.0) { type in
                                    TripTypeItem(
                                        title: type.0,
                                        icon: type.1,
                                        color: type.2,
                                        isSelected: tripType == type.0
                                    )
                                    .onTapGesture { tripType = type.0 }
                                }
                            }
                            
                            CustomInputLabel(text: "DESCRIPTION")
                            TextField("What's the plan? (optional)", text: $description, axis: .vertical)
                                .lineLimit(4, reservesSpace: true)
                                .modifier(FigmaInputStyle())
                        }
                        .padding()
                    }
                    
                    HStack(spacing: 15) {
                        Button(action: { dismiss() }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.2)))
                        }
                        
                        Button(action: {
                            tripviewModel.createNewTrip(name: tripName, destination: destination, start: startDate, end: endDate, imageData: selectedImageData)
                            dismiss()
                        }) {
                            Text("Create Trip")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.1, green: 0.2, blue: 0.3))
                                .cornerRadius(15)
                        }
                        .disabled(tripName.isEmpty || destination.isEmpty)
                        .opacity(tripName.isEmpty || destination.isEmpty ? 0.5 : 1.0)
                    }
                    .padding()
                }
            }
        }
    }
}

struct CustomInputLabel: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.gray.opacity(0.8))
            .padding(.leading, 4)
    }
}

struct FigmaInputStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(red: 0.96, green: 0.97, blue: 0.99))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.1), lineWidth: 1)
            )
    }
}

struct TripTypeItem: View {
    let title: String
    let icon: String
    let color: Color
    var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? color.opacity(0.1) : Color(red: 0.96, green: 0.97, blue: 0.99))
                    .frame(width: 65, height: 65)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isSelected ? color : Color.clear, lineWidth: 2)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? color : .gray.opacity(0.6))
            }
            
            Text(title)
                .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? .black : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    AddTripModalView(tripviewModel: TripViewModel())
}
