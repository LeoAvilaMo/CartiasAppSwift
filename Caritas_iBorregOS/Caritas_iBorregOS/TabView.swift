//
//  ContentView.swift
//  navBar
//
//  Created by Alumno on 27/08/24.
//

import SwiftUI

struct TabViews: View {
    var email: String
    @State private var errorMessage = ""
    @State private var userID: Int = 0
    @State private var userPoints: UserTotalPoints?
    
    func setUser() async{
        do {
            // Obtener el usuario con el mail
            let usuario: USUARIOS = getUsuario(email: email)
            userID = usuario.ID_USUARIO
            // Obtener los puntos y id con el mail y settear en defaults
            let userPoints = try await fetchUserTotalPoints(for: userID)
               print("User 1 Total Points: \(userPoints.totalPoints)")
            UserDefaults.standard.setValue(userPoints.totalPoints, forKey: "puntos")
            print("puntos del usuario")
            print(UserDefaults.standard.integer(forKey: "puntos"))
        } catch {
            errorMessage = "Failed to fetch events: \(error.localizedDescription)"
        }
        
        
    }
    // Colores
    private let selectedTintColor = Color(red: 0.8196078431372549, green: 0.8784313725490196, blue: 0.8431372549019608)
    private let tabBarBackgroundColor = UIColor(hex: "#009CA6")
    private let unselectedItemTintColor = UIColor(hex: "#003B5C")
    var body: some View {
        VStack {
            // Componente principal TabView
            TabView{
            EventosView()
                    .tabItem {
                        Label("Eventos", systemImage: "house")
                    }
                RetosView()
                    .tabItem {
                        Label("Retos", systemImage: "person.3.fill")
                    }
                TiendaView()
                    .tabItem {
                        Label("Tienda", systemImage: "medal")
                    }
                PerfilView()
                    .tabItem {
                        Label("Usuario", systemImage: "person.fill")
                    }
                
            }
            .background()
            // Colores cuando se seleccionan
            .tint(selectedTintColor)
            .onAppear {
                
            Task {
                await setUser() // Ejecutar setUser al aparecer la vista
                }
                           
                
                let appearance = UITabBar.appearance()
                appearance.barTintColor = tabBarBackgroundColor
                appearance.backgroundColor = tabBarBackgroundColor
                appearance.unselectedItemTintColor = unselectedItemTintColor
            }

        }
    }
}

    
#Preview {
    let exampleUserTotalPoints = UserTotalPoints(
        totalBenefitPointsSpent: "150",
        totalEventPoints: "300",
        totalPoints: "450",
        totalRetoPoints: "200")
    TabViews(email: "juan.perez@example.com")
}
