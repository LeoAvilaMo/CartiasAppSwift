//
//  PremiosCardView.swift
//  Caritas_iBorregOS
//
//  Created by Alumno on 03/10/24.
//

import SwiftUI

struct PremioCardView: View {
    let premio: PREMIOS
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Nombre del premio
            Text(premio.NOMBRE)
                .font(.headline)
                .padding([.leading, .trailing, .bottom], 10)
            
            // Descripción del premio
            Text(premio.DESCRIPCION)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding([.leading, .trailing, .bottom], 10)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}

struct PremioCardView_Previews: PreviewProvider {
    static var previews: some View {
        PremioCardView(premio: PREMIOS(ID_PREMIOS: 1, NOMBRE: "Premio 1", DESCRIPCION: "Descripción del premio."))
    }
}

