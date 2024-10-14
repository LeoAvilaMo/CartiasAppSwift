import SwiftUI

struct HistorialView: View {
    @State private var selectedSegment = 0
    @State private var events: [EVENTOS] = []
    @State private var retos: Array<RETOS> = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                HStack { Spacer() }
                Spacer()
                
                Text("Historial")
                    .font(.system(size: 35))
                    .bold()
                    .foregroundColor(darkBlueC)
                    .padding()
                
                // Barra de selección
                Picker("", selection: $selectedSegment) {
                    Text("Eventos").tag(0)
                    Text("Retos").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Divider()
                    .padding(.horizontal)
                
                ScrollView {
                    VStack {
                        
                    }
                    .padding()
                    if selectedSegment == 0 {
                        // Dynamically fetch and display events
                        if !events.isEmpty {
                            ForEach(events) { evento in
                                NavigationLink {
                                    EventDetailView(event: evento)
                                } label: {
                                    EventCardView(event: evento)
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.black)
                                }
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                            }
                        } else {
                            // Display loading or error message
                            if let errorMessage = errorMessage {
                                Text("No haz completado ningún evento")
                                    .foregroundStyle(pinkC)
                                    .bold()
                                    .font(.system(size: 20))
                            } else {
                                Text("No haz completado ningún evento")
                                    .foregroundStyle(pinkC)
                                    .bold()
                                    .font(.system(size: 20))
                            }
                        }
                    } else {
                        // Historial de Retos
                        if !retos.isEmpty {
                            ForEach(retos) { reto in
                                NavigationLink {
                                    RetoDetailView(retoX: reto)
                                } label: {
                                    RetoCardView(RetoX: reto)
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.black)
                                }
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                            }
                        } else {
                            // Display loading or error message for retos
                            if let errorMessage = errorMessage {
                                Text("No haz completado ningún reto")
                                    .foregroundStyle(pinkC)
                                    .bold()
                                    .font(.system(size: 20))
                            } else {
                                Text("No haz completado ningún reto")
                                    .foregroundColor(darkBlueC)
                            }
                        }
                    }
                }
                .background(lightGreenC)
            }
            .background(lightGreenC)
            .onAppear {
                Task {
                    do {
                        let fetchedEvents = try await fetchUserCompletedEvents(usuarioID: 1)
                        events = fetchedEvents
                        let fetchedRetos = getCompletedRETOSList(userID: myUser.ID_USUARIO)
                        retos = fetchedRetos
                    } catch {
                        errorMessage = "Failed to fetch events: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}

#Preview {
    HistorialView()
}
