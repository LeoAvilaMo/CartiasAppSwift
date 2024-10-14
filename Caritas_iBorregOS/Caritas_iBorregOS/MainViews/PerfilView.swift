//
//  PerfilView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 27/08/24.
//

import SwiftUI
import Charts

//User
let myUser = USUARIOS(ID_USUARIO: 1, NOMBRE: "", A_PATERNO: "", A_MATERNO: "", ID_TIPO_USUARIO: 1, EMAIL: "", CONTRASENA: "")

let miPerfil = getUsuario(email: "juan.perez@example.com")

struct PerfilView: View {
    
    @State private var notification: Bool = false
    @State private var retosCompletados = getRetosCompletados(usuarioID: miPerfil.ID_USUARIO)
    @State private var chartsData: Array<DATOS_FISICOS> = getDatosFisicos(userID: miPerfil.ID_USUARIO)
    
   
          
    
    var body: some View {
        let progress = Double(retosCompletados.CompletedRetos) / Double(retosCompletados.TotalRetos)
        let recentWeight = chartsData.first?.PESO ?? 0
        let recentHeight = chartsData.first?.ALTURA ?? 0
        let pesos = chartsData.map { $0.PESO }
        let fechas = chartsData.map { $0.FECHA_ACTUALIZACION }
        let BMIs = chartsData.map { $0.IMC }
        let inGlus = chartsData.map { $0.GLUCOSA }
        let pesoColor = Color(red: 0, green: 112/255, blue: 66/255)
        let bmiColor = chartC
        let inGlusColor = Color(red: 206/255, green: 111/255, blue: 0)
        NavigationStack{
            ScrollView{
                ZStack{
                    //Green background
                    VStack(alignment: .center) {
                        // Notifications and rewards buttons
                        HStack {
                            NavigationLink{
                                HistorialView()
                            }label:{
                                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                                    .resizable()
                                    .frame(width: 50, height: 45)
                                    .foregroundStyle(orangeC)
                            }
                            .alert(isPresented: $notification, content: {
                                Alert( title: Text("¡Felicidades!"), message: Text("Completaste el reto: Caminata en Chipinque 🏃"), dismissButton: .default(Text("Volver")))
                            })
                            Spacer()
                            NavigationLink{
                                PremiosView()
                            }label:{
                                Image(systemName: "gift")
                                    .resizable()
                                    .frame(width: 45, height: 45)
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
                    
                    //White card content
                    VStack{
                        //Spacer to fill the screen
                        HStack {Spacer()}
                        
                        VStack(alignment: .center){
                            //Content in the white card
                            let nombreUsuario = miPerfil.NOMBRE + " " + miPerfil.A_PATERNO + " " + miPerfil.A_MATERNO
                            Text(nombreUsuario)
                                .padding(.top, 15)
                                .foregroundStyle(blueC)
                                .font(.system(size: 40))
                                .bold()
                            
                            //Retos completados
                            RetosProgressView(progress: progress)
                            // Weight and height cards
                            PesoAlturaView(weightX: recentWeight, heightX: recentHeight)
                            
                            ChartView(graphDataX: pesos, graphDataY: fechas, unitsX: "kg", graphTitleX: "Peso 💪", chartColorX: pesoColor)
                                .padding(.bottom, 10)
                            ChartView(graphDataX: BMIs, graphDataY: fechas, unitsX: "kg/m²", graphTitleX: "IMC 🧩", chartColorX: bmiColor)
                                .padding(.bottom, 10)
                            ChartView(graphDataX: inGlus, graphDataY: fechas, unitsX: "mg/dl", graphTitleX: "Glucosa 🩸", chartColorX: inGlusColor)
                                .padding(.bottom, 10)
                        }
                        .padding(.horizontal, 1)
                        .padding(.vertical, 85)
                        VStack {}
                        .padding(25)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .background(lightTealC)
                    .cornerRadius(50)
                    .offset(y: 150)
                    .shadow(color: Color.black.opacity(0.01), radius: 5, x: 0, y: 5)
                    
                    //Profile picture
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
    }
    // Inject the presentation mode environment variable for dismissing the view
    @Environment(\.presentationMode) var presentationMode
}


#Preview {
    PerfilView()
}
