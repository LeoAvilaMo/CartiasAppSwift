import SwiftUI

struct RetosHistorialView: View {
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let lightGreenC = Color(red: 209/255, green: 224/255, blue: 215/255)

    @State private var completedRetos: [RETOS] = []  // State for storing completed retos
    @State private var errorMessage: String?
    let usuarioID: Int  // The ID of the user to fetch retos for

    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                HStack { Spacer() }
                Spacer()
                
                Text("Retos Completados")
                    .font(.system(size: 35))
                    .bold()
                    .foregroundColor(darkBlueC)
                    .padding()

                ScrollView {
                    if !completedRetos.isEmpty {
                        ForEach(completedRetos) { reto in
                            NavigationLink(destination: RetoDetailView(retoX: reto)) {
                                RetoCardView(RetoX: reto)
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.black)
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                        }
                    } else {
                        if let errorMessage = errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                        } else {
                            Text("Fetching completed retos...")
                                .foregroundColor(darkBlueC)
                        }
                    }
                }
            }
            .background(lightGreenC)
            .onAppear {
                fetchCompletedRetos()  // Fetch retos when the view appears
            }
        }
    }
    
    // Function to fetch completed retos from the API
    private func fetchCompletedRetos() {
        Task {
            do {
                let fetchedRetos = try await fetchUserCompletedRetos(usuarioID: usuarioID)
                completedRetos = fetchedRetos
            } catch {
                errorMessage = "Failed to fetch completed retos: \(error.localizedDescription)"
            }
        }
    }
}

// Function to fetch completed retos from the API
func fetchUserCompletedRetos(usuarioID: Int) async throws -> [RETOS] {
    guard let url = URL(string: "\(urlEndpoint)/user/\(usuarioID)/completed-retos") else {
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

        // Try to decode the data into an array of RETOS
        let decoder = JSONDecoder()
        let retos = try decoder.decode([RETOS].self, from: data)
        return retos
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
    RetosHistorialView(usuarioID: 1)
}
