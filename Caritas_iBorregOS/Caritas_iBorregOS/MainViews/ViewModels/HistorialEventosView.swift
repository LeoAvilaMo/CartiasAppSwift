import SwiftUI

struct CompletedEventsView: View {
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let lightGreenC = Color(red: 209/255, green: 224/255, blue: 215/255)
    
    @State private var completedEvents: [EVENTOS] = []
    @State private var errorMessage: String?
    let usuarioID: Int  // The ID of the user whose completed events we want to fetch

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Eventos Completados")
                        .font(.system(size: 35))
                        .bold()
                        .foregroundColor(darkBlueC)
                        .padding(.bottom, 20)
                    
                    if !completedEvents.isEmpty {
                        VStack(spacing: 15) {
                            ForEach(completedEvents) { event in
                                NavigationLink(destination: EventDetailView(event: event)) {
                                    EventCardView(event: event)
                                }
                            }
                        }
                    } else {
                        if let errorMessage = errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                        } else {
                            Text("Fetching completed events...")
                                .foregroundColor(darkBlueC)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .onAppear {
                    fetchCompletedEvents()
                }
            }
            .background(lightGreenC)
        }
    }
    
    private func fetchCompletedEvents() {
        Task {
            do {
                let fetchedEvents = try await fetchUserCompletedEvents(usuarioID: usuarioID)
                completedEvents = fetchedEvents
            } catch {
                errorMessage = "Failed to fetch events: \(error.localizedDescription)"
            }
        }
    }
}

func fetchUserCompletedEvents(usuarioID: Int) async throws -> [EVENTOS] {
    // Construct the URL for completed events by user ID
    guard let url = URL(string: "\(urlEndpoint)/user/\(usuarioID)/completed-events") else {
        throw URLError(.badURL)  // Throw error if URL is invalid
    }

    do {
        // Asynchronously fetch data from the API
        let (data, response) = try await URLSession.shared.data(from: url)

        // Check the HTTP response status
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)  // Invalid HTTP response
        }

        if httpResponse.statusCode != 200 {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown server error"
            print("Server Error: \(errorMessage)")  // Log the error message
            throw APIError.serverError(errorMessage)
        }

        // Print raw JSON response for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON Response: \(jsonString)")
        }

        // Try to decode the data into an array of EVENTOS
        let decoder = JSONDecoder()
        let events = try decoder.decode([EVENTOS].self, from: data)
        return events
    } catch let decodingError as DecodingError {
        // Handle JSON decoding errors
        print("Decoding Error: \(decodingError.localizedDescription)")
        throw APIError.decodingFailed
    } catch {
        // Handle other errors (e.g., networking errors)
        print("Error: \(error.localizedDescription)")
        throw error
    }
}


// Preview for SwiftUI
#Preview {
    CompletedEventsView(usuarioID: 1)
}
