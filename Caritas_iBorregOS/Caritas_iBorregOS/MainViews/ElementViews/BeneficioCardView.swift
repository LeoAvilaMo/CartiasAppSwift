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
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                
                NavigationStack{
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
                        }.padding(.leading, 30)
                        
                        Spacer()
                        Image(systemName: "arrow.down.forward.square.fill")
                            .padding(.horizontal, 25)
                            .font(.system(size: 27))
                            .foregroundColor(orangeC)
                            .clipShape(.buttonBorder)
                            .bold()
                    }
                }
            }.padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: -3, y: 3)
    }
}

#Preview {
    ZStack {
        var placeholderBeneficioX = BENEFICIOS(id:1 , NOMBRE: "Café gratis Oxxo", DESCRIPCION: "Canjeable por un café gratis en el Oxxo. Cafe original, americano, frío o caliente", PUNTOS: 100, ICONO: "fork.knife")
        BeneficioCardView(beneficioX: placeholderBeneficioX)
    }
    
}

