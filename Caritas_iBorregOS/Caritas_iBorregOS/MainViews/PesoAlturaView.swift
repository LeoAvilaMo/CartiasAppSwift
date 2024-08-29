//
//  PesoAlturaView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 28/08/24.
//

import SwiftUI

struct PesoAlturaView: View {
    
    var body: some View {
        
        HStack{
            VStack {
                ZStack {
                    Rectangle()
                        .aspectRatio(1.0, contentMode: .fit)
                        .foregroundStyle(whiteMateC)
                        .cornerRadius(10.0)
                        .shadow(radius: 5)
                    VStack {
                        Text("Peso")
                            .foregroundStyle(.gray)
                            .font(.system(size: 19))
                        Text("62.5 kg")
                            .bold()
                            .font(.system(size: 25))
                    }
                    .padding()
                }
            }
            .padding(.horizontal, 10)
            
            VStack {
                ZStack {
                    Rectangle()
                        .aspectRatio(1.0, contentMode: .fit)
                        .foregroundStyle(whiteMateC)
                        .cornerRadius(10.0)
                        .shadow(radius: 5)
                    VStack {
                        Text("Altura")
                            .foregroundStyle(.gray)
                            .font(.system(size: 19))

                        Text("172 cm")
                            .bold()
                            .font(.system(size: 25))

                    }
                    .padding()
                }
            }
            .padding(.horizontal, 10)
        }
        .padding()
    }
}

#Preview {
    PesoAlturaView()
}
