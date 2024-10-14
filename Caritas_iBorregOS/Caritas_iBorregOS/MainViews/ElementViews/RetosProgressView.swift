//
//  RetosProgressView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 14/10/24.
//

import SwiftUI

struct RetosProgressView: View {
    public var progress: Double = 0.5
    var body: some View {
        let mensajeMotivador = randomMotivationalMessage()
        VStack(alignment: .center){
            HStack{
                Image(systemName: "trophy.fill")
                    .foregroundStyle(.yellow)
                
                    .font(.system(size: 20))
                
                Text("Retos completados")
                    .font(.system(size: 20))
                    .bold()
                Image(systemName: "trophy.fill")
                    .foregroundStyle(.yellow)
                    .font(.system(size: 20))
            }
            .padding(.bottom, 25)
            .padding(.top, 5)
            .padding(.horizontal, 15)
            
            //Progress Bar with Reto text
            VStack(alignment: .center, spacing: 20) {
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
                
                Text(mensajeMotivador)
                    .foregroundStyle(pinkC)
                    .font(.system(size: 17, weight: .bold))
            }
            .padding()
        }
        .padding()
        .background(whiteC)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 6)
    }
}

#Preview {
    RetosProgressView(progress: 0.5)
}
