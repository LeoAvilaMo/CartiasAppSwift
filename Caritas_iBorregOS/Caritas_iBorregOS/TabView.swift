//
//  ContentView.swift
//  navBar
//
//  Created by Alumno on 27/08/24.
//

import SwiftUI

struct TabViews: View {
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
                let appearance = UITabBar.appearance()
                appearance.barTintColor = tabBarBackgroundColor
                appearance.backgroundColor = tabBarBackgroundColor
                appearance.unselectedItemTintColor = unselectedItemTintColor
            }

        }
    }
}

#Preview {
    TabViews()
}
