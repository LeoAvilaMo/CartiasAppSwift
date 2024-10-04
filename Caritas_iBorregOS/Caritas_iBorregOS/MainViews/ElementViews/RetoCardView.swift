//
//  RetoCardView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 03/10/24.
//

import SwiftUI

struct RetoCardView: View {
    public var RetoX: RETOS = RETOS(ID_RETO: 1, NOMBRE: "Formulario Cáritas Monterrey", DESCRIPCION: "Un reto para todos", PUNTAJE: 100)
    
    var body: some View {
        VStack{
            HStack {
                Image(systemName: "bubble.and.pencil")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding(6)
                VStack(alignment: .leading){
                    HStack{
                        Text(RetoX.NOMBRE)
                            .foregroundStyle(blueC)
                            .bold()
                            .font(.system(size: 23))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                    }
                    
                    Divider()
                    HStack{
                        Spacer()
                        Image(systemName: "star.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.yellow)
                        Text(String(RetoX.PUNTAJE))
                            .padding(.horizontal, -4)
                            .font(.system(size: 23))
                            .foregroundStyle(pinkC)
                            .bold()
                    }
                }
            }
        }
        .padding()
        .background(whiteC)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5) // Shadow at the bottom
    }
}

#Preview {
 
    RetoCardView(RetoX: RETOS(ID_RETO: 1, NOMBRE: "Formulario Cáritas Monterrey", DESCRIPCION: "Un reto para todos", PUNTAJE: 100))
    
    
}
