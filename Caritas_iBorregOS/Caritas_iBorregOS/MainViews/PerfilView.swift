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
        let mensajeMotivador = randomMotivationalMessage()
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
        
        //Overlaping things
        ZStack{
            //Green background
            VStack(alignment: .center) {
                
                // Notifications and rewards buttons
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
            
            //White card content
            ScrollView(.vertical,showsIndicators: false) {
                
                //Spacer to fill the screen
                HStack {Spacer()}
                
                VStack(alignment: .center){
                    //Content in the white card
                  
                    Text(miPerfil.NOMBRE + " " + miPerfil.A_PATERNO + " " + miPerfil.A_MATERNO)
                        .foregroundStyle(blueC)
                        .font(.system(size: 40))
                        .bold()
                    // Card de Retos
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
    // Inject the presentation mode environment variable for dismissing the view
    @Environment(\.presentationMode) var presentationMode
}


#Preview {
    PerfilView()
}
