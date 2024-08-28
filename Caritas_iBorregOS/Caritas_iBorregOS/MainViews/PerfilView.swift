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
    @State private var progress: Double = 0.2 // Current progress (99%)
    
    var body: some View {
        
        ZStack{
            VStack {
                HStack {
                    Button{
                        notification = true
                    }label:{
                        Image(systemName: "bell.fill")
                            .resizable()
                            .frame(width: 45, height: 50)
                            .foregroundStyle(orangeC)
                    }
                    .alert(isPresented: $notification, content: {
                        Alert( title: Text("¡Felicidades!"), message: Text("Completaste el reto: Caminata en Chipinque 🏃"), dismissButton: .default(Text("Volver")))
                    })
                    Spacer()
                    Button{
                        notification = true
                    }label:{
                        Image(systemName: "gift")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(pinkC)
                    }
                    .alert(isPresented: $notification, content: {
                        Alert( title: Text("¡Felicidades!"), message: Text("Completaste el reto: Caminata en Chipinque 🏃"), dismissButton: .default(Text("Volver")))
                    })
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
                    VStack(spacing: 20) {
                        ZStack(alignment: .leading) {
                            // Background Progress View
                            ProgressView(value: progress)
                                .progressViewStyle(LinearProgressViewStyle(tint: orangeC))
                                .scaleEffect(x: 1, y: 3, anchor: .center) // Make the progress bar thicker
                                .padding(.horizontal)
                            
                            // Runner Icon and Percentage Overlay
                            GeometryReader { geometry in
                                let iconSize: CGFloat = 30
                                let textWidth: CGFloat = 40 // Estimated width of the percentage text
                                let progressOffset = CGFloat(progress) * (geometry.size.width - iconSize - textWidth)
                                
                                HStack(spacing: 5) {
                                    Spacer()
                                        .frame(width: progressOffset) // Adjust the width to move the icon
                                    
                                    VStack(spacing: 0) {
                                        Text("\(Int(progress * 100))%")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(blueC)
                                        
                                        Image(systemName: "figure.run.circle.fill")
                                            .resizable()
                                            .frame(width: iconSize, height: iconSize)
                                            .foregroundColor(blueC)
                                    }
                                    .offset(y: -40) // Position icon and text above the progress bar
                                    
                                    Spacer() // Push the content to the start of the progress
                                }
                                
                            }
                            
                            .padding(.horizontal)
                        }
                        Text("Reto: Yoga mensual 🧘")
                    }
                    .frame(height: 50) // Set the height to match the overall height of the progress bar and the icon
                    .padding()
                        
                }
                .padding(.horizontal, 1)
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
