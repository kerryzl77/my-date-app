import SwiftUI

struct EventSelectionView: View {
    @State private var selectedOccasion: String = "italian_dinner"
    @State private var budget: Double = 50
    @State private var preferredTime: Date = Date()
    @State private var preferredLocation: String = ""
    @State private var additionalNotes: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var navigateToMatchView: Bool = false
    
    private let occasions = [
        ("Italian Dinner", "italian_dinner"),
        ("Coffee Date", "coffee"),
        ("Tennis", "tennis"),
        ("Hiking", "hiking"),
        ("Movie Night", "movie"),
        ("Art Gallery", "art_gallery"),
        ("Bowling", "bowling")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Text("Event Preferences")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Occasion Selection
                VStack(alignment: .leading, spacing: 10) {
                    Text("What type of hangout are you interested in?")
                        .font(.headline)
                    
                    Picker("Select Occasion", selection: $selectedOccasion) {
                        ForEach(occasions, id: \.1) { occasion in
                            Text(occasion.0).tag(occasion.1)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                // Budget Slider
                VStack(alignment: .leading, spacing: 10) {
                    Text("Budget")
                        .font(.headline)
                    
                    HStack {
                        Text("$\(Int(budget))")
                        Slider(value: $budget, in: 10...200, step: 10)
                        Text("$200+")
                    }
                }
                
                // Preferred Time
                VStack(alignment: .leading, spacing: 10) {
                    Text("Preferred Time")
                        .font(.headline)
                    
                    DatePicker("Select Time", selection: $preferredTime, displayedComponents: [.date, .hourAndMinute])
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                // Preferred Location
                VStack(alignment: .leading, spacing: 10) {
                    Text("Preferred Location")
                        .font(.headline)
                    
                    TextField("Enter neighborhood or area", text: $preferredLocation)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                // Additional Notes
                VStack(alignment: .leading, spacing: 10) {
                    Text("Additional Notes")
                        .font(.headline)
                    
                    TextEditor(text: $additionalNotes)
                        .frame(height: 100)
                        .padding(4)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                Button(action: submitPreferences) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Find My Match")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 10)
                .disabled(isLoading)
                
                NavigationLink(destination: MatchView(), isActive: $navigateToMatchView) {
                    EmptyView()
                }
            }
            .padding()
        }
        .navigationBarTitle("Event Selection", displayMode: .inline)
    }
    
    private func submitPreferences() {
        // Reset error message
        errorMessage = ""
        
        // Validate inputs
        guard !preferredLocation.isEmpty else {
            errorMessage = "Please enter a preferred location"
            return
        }
        
        // Show loading indicator
        isLoading = true
        
        // Prepare preferences dictionary
        let preferences: [String: Any] = [
            "occasion": selectedOccasion,
            "budget": budget,
            "preferredTime": preferredTime.timeIntervalSince1970,
            "preferredLocation": preferredLocation,
            "additionalNotes": additionalNotes
        ]
        
        // Call API to submit preferences
        APIService.shared.submitEventSelection(preferences: preferences) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success:
                    // Navigate to match view
                    navigateToMatchView = true
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct EventSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EventSelectionView()
        }
    }
} 