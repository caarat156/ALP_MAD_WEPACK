import SwiftUI
import Observation
import FirebaseFirestore
import FirebaseStorage

@Observable
class TripViewModel {
    var trips: [Trip] = []
    var currentUserID: String = "me"
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    init() { fetchTrips() }
    
    func calculateDaysAway(from startDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: startDate))
        return max(0, components.day ?? 0)
    }
    
    // Fungsi nambah trip baru
    func createNewTrip(name: String, destination: String, start: Date, end: Date, imageData: Data?) {
        let newTripId = UUID().uuidString
        
        // 1. Jika ada gambar, upload ke Firebase Storage dulu
        if let imageData = imageData {
            let imageRef = storage.child("trip_images/\(newTripId).jpg")
            
            imageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("❌ Gagal upload gambar: \(error.localizedDescription)")
                    return
                }
                
                // Ambil link URL setelah upload sukses
                imageRef.downloadURL { url, _ in
                    let imageUrl = url?.absoluteString
                    // Simpan ke Firestore setelah dapet URL gambar
                    self.saveToFirestore(id: newTripId, name: name, destination: destination, start: start, end: end, imageUrl: imageUrl)
                }
            }
        } else {
            // 2. Jika tidak ada gambar, simpan langsung ke Firestore
            saveToFirestore(id: newTripId, name: name, destination: destination, start: start, end: end, imageUrl: nil)
        }
    }
    
    // Fungsi pembantu untuk simpan ke database
    private func saveToFirestore(id: String, name: String, destination: String, start: Date, end: Date, imageUrl: String?) {
        var tripData: [String: Any] = [
            "id": id,
            "name": name,
            "destination": destination,
            "startDate": Timestamp(date: start),
            "endDate": Timestamp(date: end),
            "ownerId": currentUserID,
            "memberIds": [currentUserID],
            "groupProgress": 0.0
        ]
        
        if let url = imageUrl { tripData["imageUrl"] = url }
        
        db.collection("trips").document(id).setData(tripData) { error in
            if let error = error { print("❌ Gagal save: \(error.localizedDescription)") }
            else { print("✅ Trip berhasil disimpan ke Firebase!") }
        }
    }
    
    func fetchTrips() {
        db.collection("trips").whereField("memberIds", arrayContains: currentUserID)
            .addSnapshotListener { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            DispatchQueue.main.async {
                self.trips = documents.compactMap { doc in
                    let data = doc.data()
                    return Trip(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        destination: data["destination"] as? String ?? "",
                        startDate: (data["startDate"] as? Timestamp)?.dateValue() ?? Date(),
                        endDate: (data["endDate"] as? Timestamp)?.dateValue() ?? Date(),
                        ownerId: data["ownerId"] as? String ?? "",
                        memberIds: data["memberIds"] as? [String] ?? [],
                        groupProgress: data["groupProgress"] as? Double ?? 0.0,
                        imageUrl: data["imageUrl"] as? String // Ambil URL string
                    )
                }
            }
        }
    }
}
