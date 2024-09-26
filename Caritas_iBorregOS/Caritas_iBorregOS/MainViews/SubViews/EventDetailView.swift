import SwiftUI
struct EventDetailView: View {
    var event: EVENTOS  // The EVENTOS object passed to this view
    @State private var participa: Bool = false
    
    var body: some View {
        ZStack {
            Color.teal
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                // Top image with fade overlay
                ZStack(alignment: .bottom) {
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                    
                    // Fade effect at the bottom of the image
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.teal.opacity(0.9)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 80)
                }
                
                // Event title and badge section
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .firstTextBaseline) {  // Usamos firstTextBaseline para alinear con el texto base
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Evento")
                                .font(.system(size: 40))
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            
                            Text(event.NOMBRE)
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                        }
                        
                        Spacer()
                        
                        // Recompensa alineada con Evento
                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            Text("\(event.PUNTAJE)")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(Color(red: 0/255, green: 59/255, blue: 92/255))
                        .cornerRadius(25)
                    }
                    .padding()
                    .background(Color.teal)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // Event details section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Fecha:")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            Text(dateToStringEs(event.FECHA_EVENTO))
                                .font(.callout)
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                        }
                        
                        Divider()
                            .frame(width: 3, height: 60)
                            .background(Color.white)
                            .padding(.horizontal, 10)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ubicación:")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            Text("Ubicacion de detalles aquí")
                                .font(.callout)
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(Color.white)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Información:")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                        Text(event.DESCRIPCION)
                            .font(.callout)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.teal)
                
                Spacer()
                
                // Participation button at the bottom
                VStack {
                    if participa {
                        HStack {
                            Button(action: {}) {
                                Text("Registrar Asistencia")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            }
                            
                            Button(action: { participa.toggle() }) {
                                Text("Cancelar")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            }
                        }
                    } else {
                        Button(action: { participa.toggle() }) {
                            Text("Participar")
                                .font(.title)
                                .fontWeight(.heavy)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0/255, green: 59/255, blue: 92/255))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 0)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
}
struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: exampleEvent)
    }
}
