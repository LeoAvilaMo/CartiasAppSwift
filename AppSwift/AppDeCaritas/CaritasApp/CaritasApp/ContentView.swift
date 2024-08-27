//
//  ContentView.swift
//  CaritasApp
//
//  Created by Leo A.Molina on 26/08/24.
//

import SwiftUI
let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
let lightGreenC = Color(red: 209/255, green: 224/255, blue: 215/255)
let whiteC = Color(red: 255/255, green: 255/255, blue: 255/255)


struct ContentView: View {
    
    //Variables extra de prubea
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        ZStack {
            // Parte de atrás azul fuerte
            VStack {
                Spacer()
                HStack {Spacer()}
                VStack{
                    Image("logoCaritas")
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    HStack {
                        Text("Iniciar sesión")
                            .font(.system(size: 45))
                            .bold()
                            .foregroundColor(whiteC)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .offset(y: 10)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .padding()
            .background(blueC)
            
            //Tarjeta verde de adelante
            VStack (alignment: .leading){
                HStack {Spacer()}
                VStack {
                    HStack{
                        Text("Usuario")
                            .font(.title)
                            .foregroundColor(darkBlueC)
                        Spacer()
                    }
                    TextField("Introduce tu usuario", text: $username)
                    HStack{
                        Text("Constraseña")
                            .font(.title)
                            .foregroundColor(darkBlueC)
                        Spacer()
                    }
                    TextField("Introduce tu contraseña", text: $password)
                }
                .offset(y: 25)
                .padding(25)
                Spacer()
            }
            .background(lightGreenC)
            .cornerRadius(50)
            .offset(y: 220)
            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
        }
        
    }
}

#Preview {
    ContentView()
}
