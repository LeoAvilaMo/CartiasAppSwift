//
//  BeneficioCardView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 31/08/24.
//

import SwiftUI

struct BeneficioCardView: View {
    //Placeholder
    public var beneficioX: BENEFICIOS
    var body: some View {
        VStack{
            HStack{
                Image(systemName: beneficioX.ICONO)
                    .resizable()
                    .foregroundStyle(blueC)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .scaledToFit()

                Text(beneficioX.NOMBRE)
                    .font(.system(size: 25))
                Spacer()
            }
            
            HStack{
                HStack{
                    Image(systemName: "star.fill")
                        .resizable()
                        .foregroundStyle(.yellow)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                    Text(String(beneficioX.PUNTOS))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(blueC)
                }
                
                Spacer()
                Button("VER MÁS") {
                   
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 8)
                .font(.system(size: 18))
                .foregroundColor(whiteC)
                .background(orangeC)
                .clipShape(.buttonBorder)
                .cornerRadius(50)
                .bold()
            }
        }
    }
}

#Preview {
    ZStack {
        var placeholderBeneficioX = BENEFICIOS(id:1 , NOMBRE: "UN BENEFICIO", DESCRIPCION: "UNA DESCRIPCIÓN", PUNTOS: 10000, ICONO: "person.fill")
        BeneficioCardView(beneficioX: placeholderBeneficioX)
    }
    
}
