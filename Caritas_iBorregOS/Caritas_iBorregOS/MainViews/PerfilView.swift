//
//  PerfilView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 27/08/24.
//

import SwiftUI



struct PerfilView: View {
    @State private var user: String = "María Martínez"
    @State private var notification: Bool = false
    let percentage: Double = 40.0
    
    var body: some View {
        ZStack{
            VStack {
                HStack {
                    Button{
                        notification = true
                    }label:{
                        Image(systemName: "bell.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(orangeC)
                    }
                    .alert(isPresented: $notification, content: {
                        Alert( title: Text("¡Felicidades!"), message: Text("Completaste el reto: Caminata en Chipinque 🏃"), dismissButton: .default(Text("Volver")))
                    })
                    Spacer()
                }
                .padding(.horizontal, 15)
                HStack {Spacer()}
                Spacer()
            }
            .padding()
            .background(lightGreenC)
            
            ScrollView(.vertical) {
                HStack {Spacer()}
                VStack{
                    
                    Text(user)
                    .foregroundStyle(blueC)
                    .font(.system(size: 40))
                    .bold()
                    ProgressView(value: percentage, total: 100)
                        .tint(blueC)
                        .progressViewStyle(.linear)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 85)
                Spacer()
            }
            .padding()
            .background(whiteMateC)
            .cornerRadius(50)
            .offset(y: 150)
            .shadow(color: Color.black.opacity(0.01), radius: 5, x: 0, y: 5)
            VStack {
                FotoView()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 35)
                    .frame(width: 250)
                    .shadow(color: blueC,radius: 10)
                    
                Spacer()
            }
            
        }
    }
}

#Preview {
    PerfilView()
}
