//
//  PremiosView.swift
//  Caritas_iBorregOS
//
//  Created by Alumno on 03/10/24.
//
import SwiftUI

struct PremiosView: View {
    
    @State private var premiosList: [PREMIO] = getPremiosNoUsados(userID: 1)
    
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let lightGreenC = Color(red: 209/255, green: 224/255, blue: 215/255)
    let whiteC = Color(red: 255/255, green: 255/255, blue: 255/255)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    // Título
                    Text("Mis Premios")
                        .font(.system(size: 35))
                        .font(.title)
                        .bold()
                        .foregroundColor(darkBlueC)
                        .padding(.bottom, 20)
                    ForEach(Array(premiosList.enumerated()), id: \.offset){ i, premio in
                        PREMIOSSCardView(premioX: premio)
                    }
                    Spacer()
                }
                .padding()
                    
            }
            .background(lightGreenC)
        }
    }
    
    // Función para obtener datos simulados
    func obtenerPremiosSimulados() -> [PREMIOS] {
        return [
            PREMIOS(ID_PREMIOS: 1, NOMBRE: "Sesión de masaje en centro de rehabilitación", DESCRIPCION: "Disfruta de una relajante sesión de masaje en un centro especializado en rehabilitación."),
            PREMIOS(ID_PREMIOS: 2, NOMBRE: "Cupones 2x1 Cinemex", DESCRIPCION: "Obtén cupones 2x1 para disfrutar de tus películas favoritas en Cinemex."),
            PREMIOS(ID_PREMIOS: 3, NOMBRE: "Café gratis en Oxxo", DESCRIPCION: "Disfruta de un café gratis en cualquier tienda Oxxo participante."),
            PREMIOS(ID_PREMIOS: 4, NOMBRE: "Feria del libro - 2 entradas gratis", DESCRIPCION: "Accede a la Feria del Libro con 2 entradas gratuitas y disfruta de los mejores libros.")
        ]
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
