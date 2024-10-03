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
            VStack(alignment: .leading) {
                HStack {Spacer()}
                Spacer()
                Text("Retos")
                ScrollView{
                    NavigationLink{
                        TiendaView()
                    } label: {
                        VStack(alignment: .leading){
                            RetoCardView()
                        }
                        .background(whiteC)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding(.vertical, -1)
                    }
                    NavigationLink{
                        TiendaView()
                    } label: {
                        VStack(alignment: .leading){
                            RetoCardView()
                        }
                        .background(whiteC)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding()
                    }
                }
                Spacer()
            }
            .background(lightGreenC)
        }
        
        
    }
}

#Preview {
    RetosView()
}
