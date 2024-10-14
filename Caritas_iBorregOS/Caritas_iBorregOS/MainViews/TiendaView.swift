import SwiftUI

struct TiendaView: View {
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let lightGreenC = Color(red: 209/255, green: 224/255, blue: 215/255)
    let whiteC = Color(red: 255/255, green: 255/255, blue: 255/255)
    let whiteMateC = Color(red: 253/255, green: 251/255, blue: 249/255)
    let orangeC = Color(red: 255/255, green: 127/255, blue: 50/255)
    let pinkC = Color(red: 161/255, green: 90/255, blue: 149/255)
    let lightTealC = Color(red: 247/255, green: 250/255, blue: 248/255)
    let chartC = Color(red: 132/255, green: 104/255, blue: 175/255)
    let chartBackgroundC = Color(red: 227/255, green: 220/255, blue: 237/255)

    @State private var beneficios: [BENEFICIOS] = []
    @State private var errorMessage: String?
    @State private var puntos: Int?
    @State private var path = NavigationPath()
    @StateObject private var viewModel = VMTienda()
    
    struct AlertItem: Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }

    @State private var alertItem: AlertItem?
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack { Spacer() }
                
                HStack {
                    Spacer()
                    HStack {
                        if puntos != nil{
                            Text(String(puntos ?? 0))
                                .foregroundColor(Color.white)
                                .font(.system(size: 18, weight: .bold))
                        } else {
                            Text("...")
                                .foregroundColor(Color.white)
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(whiteC)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(darkBlueC)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Text("Tienda")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(darkBlueC)
                    .padding(.bottom, 20)

                ScrollView {
                    VStack(spacing: 15) {
                        if !beneficios.isEmpty {
                            ForEach(beneficios) { beneficio in
                                NavigationLink(destination: BeneficioDetailView(beneficioX: beneficio)) {
                                    BeneficioCardView(beneficioX: beneficio)
                                }
                            }
                        } else {
                            if let errorMessage = errorMessage {
                                Text("Error: \(errorMessage)")
                                    .foregroundColor(.red)
                            } else {
                                Text("Fetching events...")
                                    .foregroundColor(darkBlueC)
                            }
                        }
                    }
                    .padding()
                    .background(lightGreenC)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .frame(maxHeight: 300)
                }
            }
            .background(lightGreenC)
            .onAppear {
                Task {
                    do {
                        let fetchedBeneficios = try await viewModel.fetchBeneficios()
                        beneficios = fetchedBeneficios
                        let userID = UserDefaults.standard.integer(forKey: "usuario_id")
                        let userPoints: Int = try await (fetchUserTotalPoints(for: userID))
                        print("User \(userID) Total Points: \(userPoints)")
                        puntos = userPoints
                    } catch {
                        errorMessage = "Failed to fetch beneficios: \(error.localizedDescription)"
                    }
                }
            }
            .alert(item: $alertItem) { alertItem in
                Alert(title: Text("Error"), message: Text(alertItem.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}
#Preview {
    TiendaView()
}
