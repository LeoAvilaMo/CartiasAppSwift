import SwiftUI

struct EventDetailView: View {
    var event: EVENTOS  // The EVENTOS object passed to this view
    @State private var participa: Bool? = nil
    @State private var errorMessage: String? = nil  // For handling error messages
    @State private var asistenciaModal = false  // Control for showing the modal
    
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
                    HStack(alignment: .firstTextBaseline) {
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
                    if let participaUnwrapped = participa, participaUnwrapped {
                        Text("Ya atendiste este evento!")
                            .padding()
                            .background(darkBlueC)  // Set background color
                            .cornerRadius(15)         // Rounded corners
                            .shadow(radius: 5)
                            .foregroundColor(Color.white)
                    } else if participa == false {
                        HStack {
                            Button(action: {
                                asistenciaModal = true
                            }) {
                                Text("Registrar")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            }
                            .sheet(isPresented: $asistenciaModal) {
                                RegistrarAsistenciaModalView(event: event, isPresented: $asistenciaModal)
                            }
                            
                            Button(action: { participa?.toggle() }) {
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
                        Button(action: {
                            Task {
                                    do {
                                        let success = try await registerAttendance(usuarioID: 1, eventoID: event.ID_EVENTO)
                                        if success {
                                            print("Attendance successfully registered!")
                                            participa = false
                                        } else {
                                            print("Failed to register attendance.")
                                        }
                                    } catch {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                }
}) {
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
        .onAppear {
            Task {
                do {
                    let fetchedStatus = try await checkAttendance(usuarioID: 1, eventoID: event.ID_EVENTO)
                    participa = fetchedStatus  // Set the attendance status

                    // Safely unwrap fetchedStatus
                    if let unwrappedStatus = fetchedStatus {
                        print("Participation status: \(unwrappedStatus ? "Attended" : "Not Attended")")
                    } else {
                        print("Participation status is nil or user not registered")
                    }
                } catch {
                    errorMessage = "Failed to fetch attendance status: \(error.localizedDescription)"
                    participa = nil  // Reset the attendance status in case of error
                    print("Error fetching attendance status: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct RegistrarAsistenciaModalView: View {
    var event: EVENTOS
    @Binding var isPresented: Bool  // Use a binding to control the modal visibility
    @State private var codigoValidacion: String = ""
    
    var body: some View {
        ZStack {
            Color(lightGreenC)
                .ignoresSafeArea(.all)
            
            VStack {
                // Stylish rectangle containing "Registro de Asistencia" and event name
                VStack {
                    Text("Registro de Asistencia")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(event.NOMBRE)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .background(darkBlueC)  // Set background color
                .cornerRadius(15)         // Rounded corners
                .shadow(radius: 5)        // Add shadow for the stylish look
                
                // Input for validation code
                TextField("Código de validación", text: $codigoValidacion)
                    .keyboardType(.numberPad)  // Keyboard suited for number input
                    .font(.system(size: 15))
                    .frame(width: 200)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Button("Subir") {
                        if let codigo = Int(codigoValidacion) {
                            // Process the validation code (codigo) here
                            print("Código ingresado: \(codigo)")
                            isPresented = false  // Close the modal when the button is pressed
                        } else {
                            // Handle invalid input
                            print("El código ingresado no es válido.")
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    Button("Cerrar") {
                        isPresented = false  // Close the modal when the button is pressed
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: exampleEvent)
    }
}
