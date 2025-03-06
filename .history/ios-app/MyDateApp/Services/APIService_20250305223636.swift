import Foundation

enum APIError: Error {
    case networkError
    case invalidResponse
    case serverError(String)
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Network error. Please check your connection."
        case .invalidResponse:
            return "Invalid response from server."
        case .serverError(let message):
            return "Server error: \(message)"
        case .decodingError:
            return "Error processing data from server."
        }
    }
}

class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://api.mydateapp.com" // Replace with your actual API URL
    
    private init() {}
    
    // MARK: - Authentication
    
    func register(email: String, password: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        // In a real app, you would make an actual API call here
        // For now, we'll simulate a successful response
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Check if email is valid
            if email.hasSuffix(".edu") {
                completion(.success(()))
            } else {
                completion(.failure(.serverError("Please use a valid .edu email address")))
            }
        }
    }
    
    func verifyEmail(email: String, code: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // For demo purposes, accept any 6-digit code
            if code.count == 6 && Int(code) != nil {
                completion(.success(()))
            } else {
                completion(.failure(.serverError("Invalid verification code")))
            }
        }
    }
    
    func resendVerificationCode(email: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(()))
        }
    }
    
    // MARK: - Event Selection
    
    func submitEventSelection(preferences: [String: Any], completion: @escaping (Result<Void, APIError>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.success(()))
        }
    }
    
    // MARK: - Match
    
    func getMatch(completion: @escaping (Result<Match, APIError>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            // Create a sample match for demo purposes
            let match = Match(
                id: "match123",
                eventName: "Italian Dinner",
                location: "Bella Italia Restaurant",
                date: Date().addingTimeInterval(86400), // Tomorrow
                description: "Enjoy authentic Italian cuisine in a cozy atmosphere. This restaurant is known for its homemade pasta and excellent wine selection.",
                latitude: 37.7749,
                longitude: -122.4194,
                venueURLString: "https://www.example.com/restaurant"
            )
            
            completion(.success(match))
        }
    }
}