import Foundation
import MapKit

struct Match: Identifiable {
    let id: String
    let eventName: String
    let location: String
    let date: Date
    let description: String?
    let latitude: Double
    let longitude: Double
    let venueURLString: String?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var venueURL: URL? {
        guard let urlString = venueURLString else { return nil }
        return URL(string: urlString)
    }
}

extension Match: Hashable {
    static func == (lhs: Match, rhs: Match) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
} 