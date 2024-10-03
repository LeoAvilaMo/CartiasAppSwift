//
//  PremiosView.swift
//  Caritas_iBorregOS
//
//  Created by Alumno on 03/10/24.
//
import SwiftUI

struct PremiosView: View {
    
    @StateObject private var premioService = PremioService()
    
    
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let lightGreenC = Color(red: 209/255, green: 224/255, blue: 215/255)
    let whiteC = Color(red: 255/255, green: 255/255, blue: 255/255)
    
    // Lista de premios
    let listaPremios = [
        Premio(nombre: "Sesión de masaje en centro de rehabilitación", icono: "gift.fill", descripcion: "Disfruta de una relajante sesión de masaje en un centro especializado en rehabilitación."),
        Premio(nombre: "Cupones 2x1 Cinemex", icono: "film.fill", descripcion: "Obtén cupones 2x1 para disfrutar de tus películas favoritas en Cinemex."),
        Premio(nombre: "Café gratis en Oxxo", icono: "cup.and.saucer.fill", descripcion: "Disfruta de un café gratis en cualquier tienda Oxxo participante."),
        Premio(nombre: "Feria del libro - 2 entradas gratis", icono: "book.fill", descripcion: "Accede a la Feria del Libro con 2 entradas gratuitas y disfruta de los mejores libros.")
    ]
    
    var body: some View {
        NavigationStack {
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
                .padding(.horizontal)
                
                // Título
                Text("Premios")
                    .font(.system(size: 35))
                    .font(.title)
                    .bold()
                    .foregroundColor(darkBlueC)
                    .padding(.bottom, 20)
                
                // Lista de premios
                List(listaPremios, id: \.nombre) { premio in
                    NavigationLink(destination: PremiosDetailView(premio: premio)) {
                        PremiosCardView(premio: premio)
                    }
                }
                .listStyle(.inset)
                .scrollIndicators(.hidden)
                .cornerRadius(10)
                .padding()
            }
            .background(lightGreenC)
        }
    }
}

struct Premio:  Codable {
    let nombre: String
    let icono: String
    let descripcion: String
}



struct PremiosView_Previews: PreviewProvider {
    static var previews: some View {
        PremiosView()
    }
}
