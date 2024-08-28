import SwiftUI

struct EventosView: View {
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let lightGreenC = Color(red: 209/255, green: 224/255, blue: 215/255)
    let whiteC = Color(red: 255/255, green: 255/255, blue: 255/255)
    @State private var eventDetail = false
    
    var body: some View {
        NavigationStack{
            VStack {
                // Stack con logo y puntos
                HStack {
                    Image("logoCaritas") // CAMBIAR A LOGO VERDE
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                        .foregroundColor(blueC)
                    Spacer()
                    // Stack de puntos
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("135")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(whiteC)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(darkBlueC)
                    .cornerRadius(12)
                }
                // Titulo
                Text("Eventos")
                    .font(.system(size: 35))
                    .bold()
                    .foregroundColor(darkBlueC)
                    .padding(.bottom, 20)
                
                // Stack que contiene Cards de cada evento
                VStack(spacing: 15) {
                    NavigationLink(destination: EventDetailView()) {
                        EventCardView(
                            title: "Yoga en el parque Rufino Tamayo",
                            date: "24/01/2024",
                            points: 10,
                            iconName: "dumbbell.fill"
                        )
                    }
                    NavigationLink(destination: EventDetailView()) {
                        EventCardView(
                            title: "Meditation Workshop",
                            date: "25/01/2024",
                            points: 15,
                            iconName: "figure.walk"
                        )
                    }
                    NavigationLink(destination: EventDetailView()) {
                        EventCardView(
                            title: "Outdoor Running",
                            date: "26/01/2024",
                            points: 12,
                            iconName: "flame.fill"
                        )
                    }
                    NavigationLink(destination: EventDetailView()) {
                        EventCardView(
                            title: "Strength Training",
                            date: "27/01/2024",
                            points: 20,
                            iconName: "bolt.fill"
                        )
                    }
                }
                Spacer()
            }
            .padding()
            .background(lightGreenC)
        }

            
        }
}

#Preview {
    EventosView()
}
