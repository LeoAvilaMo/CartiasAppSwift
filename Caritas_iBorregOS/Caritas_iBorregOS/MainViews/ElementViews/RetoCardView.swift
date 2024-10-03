//
//  RetoCardView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 03/10/24.
//

import SwiftUI


struct RetoCardView: View {
    public var nombreReto: String = "Formulario de Cáritas Monterrey"
    public var puntosReto: Int = 100
    var body: some View {
        HStack{
            Image(systemName: "bubble.and.pencil")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(.black)
            VStack(alignment: .leading){
                Text(nombreReto)
                    .foregroundStyle(blueC)
                    .font(.system(size: 25, weight: .bold))
                HStack{
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 18, weight: .bold))
                    Text(String(puntosReto))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(pinkC)
                }
            }
        }
        .padding()
        
    }
}

#Preview {
    RetoCardView()
}
