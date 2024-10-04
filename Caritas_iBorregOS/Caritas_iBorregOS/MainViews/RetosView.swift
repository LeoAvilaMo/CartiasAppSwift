//
//  RetosView.swift
//  Caritas_iBorregOS
//
//  Created by Diego Torre on 28/08/24.
//

import SwiftUI

struct RetosView: View {
    var body: some View {
        NavigationStack{
            VStack(alignment: .center) {
                HStack {Spacer()}
                Spacer()
                Text("Eventos")
                    .font(.system(size: 35))
                    .bold()
                    .foregroundColor(darkBlueC)
                    .padding()
                ScrollView{
                    VStack{}
                    .padding()
                    NavigationLink{
                        TiendaView()
                    } label: {
                        RetoCardView()
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.black)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                }
                //.background(whiteMateC)
                //.clipShape(RoundedCornerShape(radius: 50, corners: [.topLeft, .topRight])) // Custom rounded top corners
                //.shadow(radius: 10)
                
            }
            .background(lightGreenC)
        }
    }
}

// Custom Shape to round only specific corners
//Chat GPT struct
struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    RetosView()
}
