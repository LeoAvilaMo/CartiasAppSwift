import SwiftUI

struct EventCardView: View {
    let title: String
    let date: String
    let points: Int
    let iconName: String
    let action: () -> Void // Action for the button click
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)  // Set both width and height
                    .padding()
                    .background(Color.teal)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.orange)
                        
                        Text(date)
                            .font(.system(size: 16))
                            .foregroundColor(.orange)
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
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray, lineWidth: 2) // Outline with rounded corners
            )
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styles (like the blue highlight)
    }
}
