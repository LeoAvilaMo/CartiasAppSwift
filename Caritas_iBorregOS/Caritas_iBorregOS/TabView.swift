//
//  ContentView.swift
//  navBar
//
//  Created by Alumno on 27/08/24.
//

import SwiftUI

struct TabViews: View {
    var body: some View {
        VStack {
            TabView{
            EventosView()
                    .tabItem {
                        Label("Usuario", systemImage: "house")
                    }
                EventosView()
                    .tabItem {
                        Label("Eventos", systemImage: "person.3.fill")
                    }
                EventosView()
                    .tabItem {
                        Label("Retos", systemImage: "medal")
                    }
                EventosView()
                    .tabItem {
                        Label("Tienda", systemImage: "person.fill")
                    }
                
            }
            .background()
            .tint(Color(red: 0.8196078431372549, green: 0.8784313725490196, blue: 0.8431372549019608))
            .onAppear(){
                UITabBar.appearance().barTintColor = UIColor(hex: "#009CA6") // Hex for blue
                UITabBar.appearance().backgroundColor = UIColor(hex: "#009CA6")
                UITabBar.appearance().unselectedItemTintColor = UIColor(hex: "#003B5C") // Hex for black
            }

        }
    }
}

#Preview {
    TabViews()
}
