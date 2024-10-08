//
//  RetosView.swift
//  Caritas_iBorregOS
//
//  Created by Diego Torre on 28/08/24.
//

import SwiftUI

struct RetosView: View {
    var body: some View {
        let retos: Array<RETOS> = getAvailableRETOS(userID: myUser.ID_USUARIO)
        /*
         let listaRETOS: Array<RETOS> = [
            RETOS(ID_RETO: 1, NOMBRE: "ENCUESTA", DESCRIPCION: "Contesta esta encuesta satisfactoriamente sobre salud mental para obtener un bono", PUNTAJE: 100),
            .init(ID_RETO: 2, NOMBRE: "SEGURIDAD", DESCRIPCION: "Completa el formulario de seguridad para obtener un bono", PUNTAJE: 100),
            .init(ID_RETO: 3, NOMBRE: "SEGURIDAD", DESCRIPCION: "Completa el formulario de seguridad para obtener un bono", PUNTAJE: 100)
            
        ]
         */
        NavigationStack{
            VStack(alignment: .center) {
                HStack {Spacer()}
                Spacer()
                Text("Retos")
                    .font(.system(size: 35))
                    .bold()
                    .foregroundColor(darkBlueC)
                    .padding()
                ScrollView{
                    VStack{}
                    .padding()
                    ForEach(retos){ reto in
                        NavigationLink{
                            RetoDetailView(retoX: reto)
                        } label: {
                            RetoCardView(RetoX: reto)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.black)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                    }
                }
                //.background(whiteMateC)
                //.clipShape(RoundedCornerShape(radius: 50, corners: [.topLeft, .topRight])) // Custom rounded top corners
                //.shadow(radius: 10)
                
            }
            .background(lightGreenC)
        }
    }
}

// Custom Shape to round only specific corners
//Chat GPT struct
struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    RetosView()
}
