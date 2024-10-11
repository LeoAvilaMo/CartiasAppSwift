//
//  PREMIOSSCardView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 10/10/24.
//

import SwiftUI

struct PREMIOSSCardView: View {
    public var premioX: PREMIO
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

                Text(premioX.NOMBRE)
                    .font(.system(size: 25))
                    .foregroundColor(Color.black)
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
                    Text(String(premioX.PUNTOS))
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
    PREMIOSSCardView(premioX: PREMIO(ID_BENEFICIO: 1, NOMBRE: "Premio de prueba", DESCRIPCION: "Esto es un premio de prueba", PUNTOS: 1))
}
