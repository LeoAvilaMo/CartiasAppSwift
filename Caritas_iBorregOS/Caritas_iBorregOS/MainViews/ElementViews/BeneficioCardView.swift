//
//  BeneficioCardView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 31/08/24.
//

import SwiftUI

struct BeneficioCardView: View {
    
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let whiteC = Color(red: 255/255, green: 255/255, blue: 255/255)
    let whiteMateC = Color (red: 253/255, green: 251/255, blue: 249/255)
    let orangeC = Color(red: 255/255, green: 127/255, blue: 50/255)
    
    // Placeholder
    public var beneficioX: BENEFICIOS
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "gift.fill")
                    .resizable()
                    .foregroundStyle(blueC)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .scaledToFit()
                    .padding()

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
                        .padding(.leading, 20)
                    Text(String(beneficioX.PUNTOS))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(blueC)
                }
                
                Spacer()
                Button(action: {
                }) {
                    HStack {
                        Image(systemName: "arrow.down.right.square.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(orangeC)
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 8)
                }
            }
        }.background(.white)
            .cornerRadius(20)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        
    }
}

#Preview {
    ZStack {
        var placeholderBeneficioX = BENEFICIOS(id:1 , NOMBRE: "UN BENEFICIO", DESCRIPCION: "UNA DESCRIPCIÓN", PUNTOS: 10000, ICONO: "person.fill")
        BeneficioCardView(beneficioX: placeholderBeneficioX)
    }
    
}
