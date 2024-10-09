//
//  RetoDetailView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 07/10/24.
//

import SwiftUI

struct RetoDetailView: View {
    public var retoX: RETOS
    @State var participa: Bool = true
    var body: some View {
        ZStack {
            Color.teal
                .ignoresSafeArea(.all)
            VStack(spacing: 0) {
                // Top image with fade overlay
                ZStack(alignment: .bottom) {
                    Image("placeHolderReto")
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
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(retoX.NOMBRE)
                            .font(.system(size: 45))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            Text(String(retoX.PUNTAJE))
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
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    Spacer()
                }
                VStack(alignment: .leading) {
                    Divider()
                        .background(Color.white)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descripción:")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                        Text(retoX.DESCRIPCION)
                            .font(.callout)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                        Spacer()
                        Link(destination: URL(string: "https://dailykitten.com/")!){
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
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.teal)

                Spacer()
            }
        }
    }
}

#Preview {
    RetoDetailView(retoX: RETOS(ID_RETO: 1, NOMBRE: "Encuesta Sin Nombre", DESCRIPCION: "Esta es la descripción de un reto.", PUNTAJE: 100))
}
