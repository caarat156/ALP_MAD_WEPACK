import SwiftUI
import Observation
import FirebaseFirestore
import FirebaseAuth

@Observable
class TripViewModel {
    var trips: [Trip] = []
    
    // Selalu ambil UID asli dari Firebase Auth, bukan hardcode
    var currentUserID: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    private let db = Firestore.firestore()
    private var snapshotListener: ListenerRegistration?
    
    init() { fetchTrips() }
    
    func calculateDaysAway(from startDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: startDate))
        return max(0, components.day ?? 0)
    }
    
    // Fungsi nambah trip baru
    func createNewTrip(name: String, destination: String, start: Date, end: Date) {
        let newTripId = UUID().uuidString
        saveToFirestore(id: newTripId, name: name, destination: destination, start: start, end: end)
    }
    
    // Fungsi pembantu untuk simpan ke database
    private func saveToFirestore(id: String, name: String, destination: String, start: Date, end: Date) {
        let uid = currentUserID
        guard !uid.isEmpty else {
            print("❌ Gagal save: user belum login")
            return
        }
        
        let tripData: [String: Any] = [
            "id": id,
            "name": name,
            "destination": destination,
            "startDate": Timestamp(date: start),
            "endDate": Timestamp(date: end),
            "ownerId": uid,
            "memberIds": [uid],
            "groupProgress": 0.0
        ]
        
        db.collection("trips").document(id).setData(tripData) { error in
            if let error = error { print("❌ Gagal save: \(error.localizedDescription)") }
            else { print("✅ Trip berhasil disimpan ke Firebase!") }
        }
    }
    
    func fetchTrips() {
        let uid = currentUserID
        guard !uid.isEmpty else {
            print("⚠️ fetchTrips: user belum login, trips dikosongkan")
            trips = []
            return
        }
        
        // Batalkan listener lama jika ada (misalnya saat ganti akun)
        snapshotListener?.remove()
        
        snapshotListener = db.collection("trips")
            .whereField("memberIds", arrayContains: uid)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self = self,
                      let documents = snapshot?.documents else { return }
                
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
                            groupProgress: data["groupProgress"] as? Double ?? 0.0
                        )
                    }
                }
            }
    }
}
