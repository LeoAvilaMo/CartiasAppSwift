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
let whiteMateC = Color (red: 253/255, green: 251/255, blue: 249/255)
let orangeC = Color(red: 255/255, green: 127/255, blue: 50/255)
let pinkC = Color(red: 161/255, green: 90/255, blue: 149/255)
let lightTealC = Color(red: 247/255, green: 250/255, blue: 248/255)
let chartC = Color(red: 132/255, green: 104/255, blue: 175/255)
let chartBackgroundC = Color(red: 227/255, green: 220/255, blue: 237/255)

struct ContentView: View {
    
    // Variables extra de prubea
    @State private var username = ""
    @State private var password = ""
    @State private var signIn = false
    @State private var logInAlert = false
    
    var body: some View {
        NavigationStack{
            if signIn {
                TabViews()
            } else {
                ZStack {
                    // Parte de atrás azul fuerte
                    VStack {
                        Spacer()
                        HStack {Spacer()}
                        VStack{
                            Image("logoCaritas")
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                .foregroundColor(whiteMateC)
                            HStack {
                                Text("Iniciar sesión")
                                    .font(.system(size: 45))
                                    .bold()
                                    .foregroundColor(whiteMateC)
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
                                Link(destination: URL(string: "https://dailykitten.com/")!){
                                    Text("¿Olvidaste tu contraseña?").underline()
                                }
                                .font(.system(size: 20))
                                .foregroundStyle(Color.black)
                                
                            }
                            .offset(y: 10)
                            
                            //Iniciar sesión
                            Button("Iniciar sesión"){
                                if (username == "Admin" && password == "admin"){
                                    signIn = true
                                } else {
                                    logInAlert.toggle()
                                    username = ""
                                    password = ""
                                }
                            }
                            .alert(isPresented: $logInAlert, content: {
                                Alert( title: Text("Error al iniciar sesión"), message: Text("Introduce correctamente tu usuario y/o contraseña."), dismissButton: .default(Text("Volver")))
                            })
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
    }
}

#Preview {
    ContentView()
}
