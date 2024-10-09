//
//  PesoAlturaView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 28/08/24.
//

import SwiftUI

struct PesoAlturaView: View {
    public var weightX: Float = 62.5
    public var heightX: Float = 1.80
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
                        Text(String(format: "%.1f", weightX) + " kg")
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

                        Text(String(Int(heightX*100)) + " cm")
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
    PesoAlturaView(weightX: 62.5, heightX: 167.2)
}
