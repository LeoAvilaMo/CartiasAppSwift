//
//  PremioCardView.swift
//  Caritas_iBorregOS
//
//  Created by Yolis on 16/09/24.
//
import SwiftUI
struct PremioCardView: View {
    let name: String
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    
    var body: some View {
        HStack {
            Image(systemName: "giftcard.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .padding()
                .background(Color.gray)
                .clipShape(Circle())
                .cornerRadius(10)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(darkBlueC)
                
            }
            .padding(.leading, 10)
            
            Spacer()
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.3), radius: 3, x: -3, y: 3)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PremioCardView(
        name: "Café gratis en el Oxxo"
    )
}
