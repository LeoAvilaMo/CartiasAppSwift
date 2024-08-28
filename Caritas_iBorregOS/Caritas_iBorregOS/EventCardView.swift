import SwiftUI

struct EventCardView: View {
    let title: String
    let date: String
    let points: Int
    let iconName: String
    let action: () -> Void // Action for the button click
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)  // Set both width and height
                .padding()
                .background(Color.teal)
                .cornerRadius(10)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Color.orange)
                        
                        Text(date)
                            .font(.system(size: 16))
                            .foregroundColor(darkBlueC)
                    }
                }

            }
            .padding(.leading, 10)
            
            Spacer()
            
            Text("\(points) pts")
                .font(.system(size: 16, weight: .bold))
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color.purple)
                .cornerRadius(12)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white) // Match background color with the card's background
        .cornerRadius(15) // Apply the corner radius to match the stroke
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 2) // Outline with rounded corners
        )
        .shadow(radius: 2)
        .buttonStyle(PlainButtonStyle()) // Remove default button styles (like the blue highlight)
    }
}

#Preview{
    EventCardView(
        title: "Yoga en el parque Rufino Tamayo",
        date: "24/01/2024",
        points: 10,
        iconName: "dumbbell.fill",
        action: {}
    )
}
