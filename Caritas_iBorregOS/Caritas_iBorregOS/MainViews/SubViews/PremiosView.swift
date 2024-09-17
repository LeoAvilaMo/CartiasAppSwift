//
//  PremiosView.swift
//  Caritas_iBorregOS
//
//  Created by Yolis on 16/09/24.
//
import SwiftUI
struct PremiosView: View {
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let lightGreenC = Color(red: 209/255, green: 224/255, blue: 215/255)
    let whiteC = Color(red: 255/255, green: 255/255, blue: 255/255)
    @State private var eventDetail = false
    
    var body: some View {
        NavigationStack{
            VStack {
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
                    .cornerRadius(20)
                }
                // Titulo
                Text("Premios")
                    .font(.system(size: 35))
                    .font(.title)
                    .bold()
                    .foregroundColor(darkBlueC)
                    .padding(.bottom, 20)
                
                // Stack que contiene Cards de cada evento
                VStack(spacing: 15) {
                    NavigationLink(destination: PremiosDetailView()) {
                        PremioCardView(
                            name: "Sesión de masaje en centro de rehabilitación"
                        )
                    }
                    NavigationLink(destination: PremiosDetailView()) {
                        PremioCardView(
                            name: "Cupones 2x1 Cinemex"
                        )
                    }
                    NavigationLink(destination: PremiosDetailView()) {
                        PremioCardView(
                            name: "Café gratis en Oxxo"
                        )
                    }
                    NavigationLink(destination: PremiosDetailView()) {
                        PremioCardView(
                            name: "Feria del libro - 2 entradas gratis"
                        )
                    }
                }
                Spacer()
            }
            .padding()
            .background(lightGreenC)
        }
            
        }
}

#Preview {
    PremiosView()
}
