//
//  TiendaView.swift
//  Caritas_iBorregOS
//
//  Created by Diego Torre on 28/08/24.
//

import SwiftUI

struct TiendaView: View {
    // Colores personalizados
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

    // ViewModel
    @StateObject private var viewModel = ViewModelTienda()
    
    @State private var alertItem: AlertItem?

    var body: some View {
        NavigationStack {
            VStack {
                HStack { Spacer() }
                
                // Stack con logo y puntos
                HStack {
                    Spacer()
                    // Stack de puntos
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("135")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(whiteC)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(darkBlueC)
                    .cornerRadius(12)
                }
                .padding(.horizontal)

                // Titulo
                Text("Tienda")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(darkBlueC)
                    .padding(.bottom, 20)

                // Lista de beneficios
                VStack {
                    List(viewModel.beneficios) { beneficio in // Usar la lista de beneficios del ViewModel
                        NavigationLink(destination: BeneficioDetailView(beneficioX: beneficio)) {
                            BeneficioCardView(beneficioX: beneficio)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollIndicators(.hidden)
                }
                .background(lightGreenC)
                .cornerRadius(10)
                .padding()
                .offset(y: -10)
            }
            .background(lightGreenC)
            .onAppear {
                viewModel.fetchBeneficios()
                // Manejo del error
                if let errorMessage = viewModel.errorMessage {
                    alertItem = AlertItem(message: errorMessage)
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
