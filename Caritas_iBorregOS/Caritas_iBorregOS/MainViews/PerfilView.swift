//
//  PerfilView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 27/08/24.
//

import SwiftUI
import Charts

var graphData = [
    PesoPorMes(month: "Mayo", weight: 55.5),
    PesoPorMes(month: "Jun", weight: 80.5),
    PesoPorMes(month: "Jul", weight: 57.1),
    PesoPorMes(month: "Ago", weight: 62.5),
]

struct PerfilView: View {
    @State private var user: String = "María Martínez"
    @State private var notification: Bool = false
    @State private var progress: Double = 0.2 // Current progress (99%)
    
    @State private var usuario: USUARIOS?
    @State private var errorMessage: String?
    
    var body: some View {
        
        //Overlaping things
        ZStack{
            
            //Green background
            VStack {
                
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
                
                VStack{
                    
                    //Content in the white card
                    Text(usuario?.NOMBRE ?? "SN")
                        .foregroundStyle(blueC)
                        .font(.system(size: 40))
                        .bold()
                    
                    //Progress Bar with Reto text
                    VStack(spacing: 20) {
                        
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
                        
                        Text("Reto: ")
                            .bold()
                        + Text("Yoga mensual 🧘")
                            .foregroundStyle(pinkC)
                    }
                    .frame(height: 50)
                    .padding()
                    
                    // Weight and height cards
                    PesoAlturaView()
                    
                    //Charts
                    VStack (alignment: .leading){
                        Text("Tu progreso 🏃‍➡️")
                            .font(.title)
                            .bold()
                            .foregroundStyle(chartC)
                        Chart{
                            ForEach(graphData) { d in
                                BarMark(
                                    x: PlottableValue.value("Mes",d.month), y: PlottableValue.value("Peso", d.weight))
                                .foregroundStyle(chartC)
                                .annotation{
                                    Text(String("\(d.weight) kg"))
                                        .foregroundStyle(chartC)
                                }
                            }
                            
                        }
                        .chartYAxis {
                            AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                        }
                        .chartYAxis(.hidden)
                        .chartXAxis {
                            AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                        }
                        .frame(height: 200)
                        .padding()
                    }
                    .padding()
                    .background(chartBackgroundC)
                    .cornerRadius(10)
                    
                }
                .padding(.horizontal, 1)
                .padding(.vertical, 85)
                Spacer()
            }
            .padding()
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
        .onAppear{
            Task {
                do{
                    let fetchUser = try await fetchUsuario(usuarioID: 1)
                    usuario = fetchUser
                } catch {
                    errorMessage = "Error fetching user: \(error.localizedDescription)"
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
