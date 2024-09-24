//
//  TiendaView.swift
//  Caritas_iBorregOS
//
//  Created by Diego Torre on 28/08/24.
//

import SwiftUI

struct TiendaView: View {
    var body: some View {
        NavigationStack{
            VStack {
                HStack{Spacer()}
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
                
                // Lista
                VStack{
                    List(listaBeneficios){ beneficio in
                        NavigationLink (destination: PremiosDetailView()){
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
        }
    }
}

#Preview {
    TiendaView()
}

