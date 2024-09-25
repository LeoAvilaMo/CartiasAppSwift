import SwiftUI

struct EventDetailView: View {
    var event: EVENTOS  // The EVENTOS object passed to this view
    @State private var participa: Bool = false
    var body: some View {
        
            VStack(spacing: 0) {
                // Top image with overlayed content
                ZStack(alignment: .bottom) {
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                    
                    // Title and badge overlay
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Evento")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Text(event.NOMBRE)  // Use the name from the EVENTOS object
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            // Points badge
                            HStack(spacing: 5) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("\(event.PUNTAJE)")  // Use the points from the EVENTOS object
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        .padding()
                        .background(LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.7)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    }
                }

                // Event details section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        // Date information
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Fecha:")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(dateToString(event.FECHA_EVENTO))  // Convert Date to String
                                .font(.body)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Location information
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ubicación:")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Location details here")  // Add dynamic location if available
                                .font(.body)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(Color.white)

                    // Event description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Información:")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(event.DESCRIPCION)  // Use the description from the EVENTOS object
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    if (participa){
                        HStack{
                            Button(action: {
                                // Action when button is tapped
                            }) {
                                Text("Registrar Asistencia")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)  // Set the background color to green
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                           
                            Button(action: {
                                participa.toggle()
                            }) {
                                Text("Cancelar")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)  // Set the background color to green
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }

                        }
                    } else{
                        Button(action: {
                            participa.toggle()
                        }) {
                            Text("Participar")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    
                }
                .padding()
                .background(Color.teal)
                .cornerRadius(25, corners: [.topLeft, .topRight])
            }
            .ignoresSafeArea()
            .navigationBarTitle("", displayMode: .inline)
        }

    // Helper function to convert Date to a displayable string
    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }
}

// Helper extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Preview
struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: exampleEvent)
    }
}
