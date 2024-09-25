//
//  EventCrdMidView.swift
//  Caritas_iBorregOS
//
//  Created by Diego Torre on 24/09/24.
//

import SwiftUI

struct EventCardView: View {
    let event: EVENTOS
    
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .padding()
                .background(Color.teal)
                .cornerRadius(10)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(event.NOMBRE)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Color.orange)
                        
                        Text("Fecha: \(formattedDate(event.FECHA_EVENTO))")
                            .font(.system(size: 16))
                            .foregroundColor(darkBlueC)
                    }
                }

            }
            .padding(.leading, 10)
            
            Spacer()
            
            Text("Puntos: \(event.PUNTAJE)")
                .font(.system(size: 16, weight: .bold))
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color.purple)
                .cornerRadius(12)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 2)
        )
        .shadow(radius: 2)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview{
    EventCardView(
        event:exampleEvent
    )
}
