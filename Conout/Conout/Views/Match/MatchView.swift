import SwiftUI
import MapKit

struct MatchView: View {
    @State private var match: Match? = nil
    @State private var isLoading: Bool = true
    @State private var errorMessage: String = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView("Finding your perfect match...")
                        .padding(.top, 50)
                } else if let match = match {
                    // Match details
                    VStack(spacing: 15) {
                        Text("Your Match is Ready!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        Text("We've found the perfect event for you")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Divider()
                        
                        // Event details
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.blue)
                                Text(match.eventName)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.red)
                                Text(match.location)
                                    .font(.headline)
                            }
                            
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.green)
                                Text(match.formattedDate)
                                    .font(.headline)
                            }
                            
                            if let description = match.description {
                                Text(description)
                                    .padding(.top, 5)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.1)) // Replace UIColor.systemGray6
                        .cornerRadius(12)
                        
                        // Map view
                        Map(coordinateRegion: $region, annotationItems: [match]) { item in
                            MapMarker(coordinate: item.coordinate, tint: .red)
                        }
                        .frame(height: 200)
                        .cornerRadius(12)
                        .padding(.vertical)
                        
                        // Action buttons
                        HStack(spacing: 15) {
                            Button(action: {
                                // Open in Maps app
                                openInMaps()
                            }) {
                                Label("Directions", systemImage: "map")
                                    .frame(maxWidth: .infinity)
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button(action: {
                                // Open restaurant/venue website or info
                                openVenueInfo()
                            }) {
                                Label("Venue Info", systemImage: "info.circle")
                                    .frame(maxWidth: .infinity)
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Navigate to feedback screen
                        }) {
                            Text("Submit Feedback After Event")
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2)) // Replace UIColor.systemGray4
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                        .padding(.top, 10)
                    }
                    .padding()
                } else if !errorMessage.isEmpty {
                    VStack {
                        Text("Oops!")
                            .font(.title)
                            .padding(.bottom, 5)
                        
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Try Again") {
                            loadMatch()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top, 50)
                }
            }
        }
        .navigationTitle("Your Match")
        .onAppear {
            loadMatch()
        }
    }
    
    private func loadMatch() {
        isLoading = true
        errorMessage = ""
        
        APIService.shared.getMatch { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let match):
                    self.match = match

                        self.region = MKCoordinateRegion(
                            center: match.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func openInMaps() {
        guard let match = match else { return }
        
        let placemark = MKPlacemark(coordinate: match.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = match.location
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    private func openVenueInfo() {
        guard let match = match, let url = match.venueURL else { return }
        openURL(url)
    }
    
    private func openURL(_ url: URL) {
        #if os(iOS)
        // Use SwiftUI's environment modifier for opening URLs in iOS 14+
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        UIApplication.shared.open(url)
        #endif
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MatchView()
        }
    }
}
