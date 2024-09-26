import SwiftUI

struct BeneficioDetailView: View {
    var beneficioX: BENEFICIOS
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let lightGreenC = Color(red: 209/255, green: 224/255, blue: 215/255)
    let whiteC = Color(red: 255/255, green: 255/255, blue: 255/255)
    let orangeC = Color(red: 255/255, green: 127/255, blue: 50/255)
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @StateObject private var viewModel = ViewModelTienda()
    @State private var puntosUsuario: Int = 0
    @State private var showResponseAlert = false
    @State private var showMessage: Bool = false
    @State private var message: String = ""
    @State private var alertType: AlertType?
    
        
        enum AlertType {
            case confirmation
            case response
        }
    
    var body: some View {
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
                
                Text(beneficioX.NOMBRE ?? "Nombre no disponible")
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
                        Text("\(puntosUsuario)")
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
                
                
                if let benefitDescription = viewModel.currentBenefitDescription {
                    Text(benefitDescription)
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding()
                } else {
                    Text("Cargando descripción...")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Spacer()
                
                Button(action: {
                                showAlert = true
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
                                     
                                        viewModel.nuevoBeneficioUsuario(
                                            idBeneficio: beneficioX.id,
                                            idUsuario: 1,
                                            puntosUsuario: viewModel.puntosUsuario,
                                            puntosBeneficio: beneficioX.PUNTOS
                                        )
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            if let responseMessage = viewModel.responseMessage {
                                                message = responseMessage
                                            } else {
                                                message = "No se pudo canjear el beneficio."
                                            }
                                            showMessage = true
                                        }
                                    },
                                    secondaryButton: .cancel(Text("No")) {
                                    }
                                )
                            }
                            
                            if showMessage {
                                Text(message)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding()
                                    .transition(.slide)
                                    //.animation(.easeInOut) //cambiar para xcode 15.4 en adelante
                            }
                        }
        }
    }
}


#Preview {
    
    BeneficioDetailView(beneficioX: BENEFICIOS(ID_BENEFICIO: 1, NOMBRE: "Café gratis Oxxo", DESCRIPCION: "prueba", PUNTOS: 100))
}
