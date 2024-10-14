//
//  PremiosView.swift
//  Caritas_iBorregOS
//
//  Created by Alumno on 03/10/24.
//
import SwiftUI

struct PremiosView: View {
    
    @State private var premiosList: [PREMIO] = getPremiosNoUsados(userID: 1)
    
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let lightGreenC = Color(red: 209/255, green: 224/255, blue: 215/255)
    let whiteC = Color(red: 255/255, green: 255/255, blue: 255/255)
    
    var body: some View {
        ScrollView {
            HStack {Spacer()}
            // Título
            Text("Mis Premios")
                .font(.system(size: 35))
                .font(.title)
                .bold()
                .foregroundColor(darkBlueC)
                .padding(.bottom, 20)
            ForEach(Array(premiosList.enumerated()), id: \.offset){ i, premio in
                PREMIOSSCardView(premioX: premio)
            }
            Spacer()
        }
        .padding(.horizontal)
        .background(lightGreenC)
    }
}

struct PremiosView_Previews: PreviewProvider {
    static var previews: some View {
        PremiosView()
    }
}
