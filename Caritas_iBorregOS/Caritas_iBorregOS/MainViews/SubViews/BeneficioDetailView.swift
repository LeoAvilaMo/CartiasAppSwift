import SwiftUI

struct BeneficioDetailView: View {
    var beneficioX: BENEFICIOS
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let lightGreenC = Color(red: 209/255, green: 224/255, blue: 215/255)
    let whiteC = Color(red: 255/255, green: 255/255, blue: 255/255)
    let orangeC = Color(red: 255/255, green: 127/255, blue: 50/255)
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = VMTienda()
    @State private var showAlert = false
    @State private var showResponseAlert = false
    @State private var showMessage: Bool = false
    @State private var message: String = ""
    @State private var alertType: AlertType?
    @State private var idUsuario: Int = 1
    
    
    
    enum AlertType {
        case confirmation
        case response
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                lightGreenC
                    .edgesIgnoringSafeArea(.all)
                
                GeometryReader { geometry in
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        
                        path.move(to: CGPoint(x: 0, y: height * 0.65))
                        
                        for x in stride(from: 0, to: width, by: 1) {
                            let y = height * 0.6 + (x - width / 2) * (x - width / 2) / (width * -0.9)
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                        
                        path.addLine(to: CGPoint(x: width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                        path.closeSubpath()
                    }
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [blueC, blueC]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                }
                .edgesIgnoringSafeArea(.bottom)
                
                VStack(spacing: 20) {
                    Image(systemName: "gift.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(blueC)
                    
                    Text(beneficioX.NOMBRE)
                        .font(.system(size: 28))
                        .bold()
                        .foregroundColor(darkBlueC)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Spacer()
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .frame(width: 24, height: 24)
                            Text("\(beneficioX.PUNTOS)")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(whiteC)
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 25)
                        .background(blueC)
                        .cornerRadius(50)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Text(beneficioX.DESCRIPCION)
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        showAlert = true
                        Task{
                            do{
                                // Llama a la función para canjear el beneficio
                                let result = try await viewModel.redeemBenefit(usuarioID: idUsuario, beneficioID: beneficioX.ID_BENEFICIO)
                                DispatchQueue.main.async {
                                    message = result // Mensaje de la respuesta
                                    showMessage = true // Mostrar mensaje en la vista
                                }
                                
                            }catch {
                                    // Manejar el error si algo falla
                                    DispatchQueue.main.async {
                                        message = "Ocurrió un error al intentar canjear el beneficio."
                                        showMessage = true
                                    }
                                    print("Error: \(error)")
                                }
                            }
                        
                            }) {
                        Text("CANJEAR BENEFICIO")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                            .background(Color.orange)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Confirmación"),
                            message: Text("¿Deseas canjear tus puntos por este beneficio?"),
                            primaryButton: .default(Text("Sí")) {
                                // Llamada a la función async en un Task
                                Task {
                                    do {
                                        // Llama a la función para canjear el beneficio
                                        let result = try await viewModel.redeemBenefit(usuarioID: idUsuario, beneficioID: beneficioX.ID_BENEFICIO)
                                        
                                        DispatchQueue.main.async {
                                            message = result // Mensaje de la respuesta
                                            showMessage = true // Mostrar mensaje en la vista
                                        }
                                        
                                    } catch {
                                        // Manejar el error si algo falla
                                        DispatchQueue.main.async {
                                            message = "Ocurrió un error al intentar canjear el beneficio."
                                            showMessage = true
                                        }
                                        print("Error: \(error)")
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .alert(isPresented: $showMessage) {
                        Alert(
                            title: Text("Respuesta"),
                            message: Text(message),
                            dismissButton: .default(Text("Aceptar")) {
                                // Cerrar la vista después de mostrar el mensaje
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                }
            }
        }.navigationBarBackButtonHidden(true) // Ocultar el botón de regreso predeterminado
        .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.backward") // Cambia esto por el ícono que desees
                        .font(.system(size: 20))
                        .foregroundColor(blueC)// Ajusta el tamaño del ícono según sea necesario
                    Text("Volver")
                        .font(.headline)
                    .foregroundColor(blueC)// Puedes ajustar la fuente según tus preferencias
                }
            })

        
    }
}

#Preview {
    
    BeneficioDetailView(beneficioX: BENEFICIOS(ID_BENEFICIO: 1, NOMBRE: "Café gratis Oxxo", DESCRIPCION: "prueba", PUNTOS: 100))
}

/*Task {
    if (puntosDeUser >= beneficioX.PUNTOS)
    {
        do {
            // Llama a la función para canjear el beneficio
            let result = try await viewModel.redeemBenefit(usuarioID: idUsuario, beneficioID: beneficioX.ID_BENEFICIO)
            
            DispatchQueue.main.async {
                message = result // Mensaje de la respuesta
                showMessage = true // Mostrar mensaje en la vista
            }
            
        } catch {
            // Manejar el error si algo falla
            DispatchQueue.main.async {
                message = "Ocurrió un error al intentar canjear el beneficio."
                showMessage = true
            }
            print("Error: \(error)")
        }
    }
} */
