import SwiftUI

struct EventosView: View {
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let lightGreenC = Color(red: 209/255, green: 224/255, blue: 215/255)
    let whiteC = Color(red: 255/255, green: 255/255, blue: 255/255)
    
    @State private var events: [EVENTOS] = []
    @State private var errorMessage: String?   
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Stack with logo and points
                    HStack {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("135")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(whiteC)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(darkBlueC)
                        .cornerRadius(12)
                    }
                    
                    // Title
                    Text("Eventos")
                        .font(.system(size: 35))
                        .bold()
                        .foregroundColor(darkBlueC)
                        .padding(.bottom, 20)
                    
                    // If events are successfully fetched, display them as cards
                    if !events.isEmpty {
                        VStack(spacing: 15) {
                            ForEach(events) { event in
                                NavigationLink(destination: EventDetailView(event: event)
                                    ) {
                                    EventCardView(event: event)
                                }
                            }
                        }
                    } else {
                        // Placeholder when fetching events or error occurs
                        if let errorMessage = errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                        } else {
                            Text("Fetching events...")
                                .foregroundColor(darkBlueC)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .onAppear {
                    // Fetch events when the view appears
                    Task {
                        do {
                            let fetchedEvents = try await fetchEvents()
                            events = fetchedEvents
                        } catch {
                            errorMessage = "Failed to fetch events: \(error.localizedDescription)"
                        }
                    }
                }
            }
            .background(lightGreenC)
        }
    }
    
    // Inject the presentation mode environment variable for dismissing the view
    @Environment(\.presentationMode) var presentationMode
}

#Preview {
    EventosView()
}
