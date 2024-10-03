//
//  PremiosCardView.swift
//  Caritas_iBorregOS
//
//  Created by Alumno on 03/10/24.
//

import SwiftUI

struct PremioCardView: View {
    let premio: Premio
    
    var body: some View {
        VStack(alignment: .leading) {
            // Imagen del ícono del premio
            Image(premio.icono)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding()
            
            // Nombre del premio
            Text(premio.nombre)
                .font(.headline)
                .padding([.leading, .trailing, .bottom], 10)
            
            // Descripción del premio
            Text(premio.descripcion)
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
        PremioCardView(premio: Premio(nombre: "Premio 1", icono: "icono_premio", descripcion: "Descripción del premio."))
    }
}
