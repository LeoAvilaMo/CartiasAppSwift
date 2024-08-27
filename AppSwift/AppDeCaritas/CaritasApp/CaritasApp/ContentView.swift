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
    @State private var signIn = false
    @State private var passwordAlert = false
    
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
                VStack (alignment: .leading) {
                    //Usuario
                    Text("Usuario")
                            .font(.title)
                            .foregroundColor(darkBlueC)
                    TextField("Introduce tu usuario", text: $username)
                        .font(.system(size: 23))
                    Divider()
                    
                    //Contraseña
                    Text("Constraseña")
                            .font(.title)
                            .foregroundColor(darkBlueC)
                    SecureField("Introduce tu contraseña", text: $password)
                        .font(.system(size: 23))
                    Divider()
                    //Olvidé mi contraseña
                    HStack{
                        Spacer()
                        Button("¿Perdiste tu contraseña?"){
                            passwordAlert = true
                        }
                        .alert(isPresented: $passwordAlert, content: {
                            Alert(title: Text("(81) 1340-2090"), message: Text("Ponte en contacto con el número de teléfono para recuperar tu contraseña"), dismissButton: .default(Text("Volver")))
                        })
                        .font(.system(size: 18))
                    }
                    .offset(y: 10)
                    
                    //Iniciar sesión
                    Button("Iniciar sesión"){
                        if username == "Juan" && password == "1234"{
                            signIn = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(15)
                    .font(.system(size: 25))
                    .foregroundColor(whiteC)
                    .background(darkBlueC)
                    .clipShape(.buttonBorder)
                    .cornerRadius(20)
                    .offset(y: 75)
                }
                .offset(y: 40)
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
