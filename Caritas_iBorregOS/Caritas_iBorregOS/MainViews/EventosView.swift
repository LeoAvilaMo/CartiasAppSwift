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
                    
                    // Titulo
                    Text("Eventos")
                        .font(.system(size: 35))
                        .bold()
                        .foregroundColor(darkBlueC)
                        .padding(.bottom, 20)
                    // Si se obtuvieron los eventos, renderizar cartas
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
                        // Hacer display de mensaje cuando suceda un error
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
                    
                    // Cuando aparezca nuestro view, hacer el fetch de eventos
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
}

#Preview {
    EventosView()
}
