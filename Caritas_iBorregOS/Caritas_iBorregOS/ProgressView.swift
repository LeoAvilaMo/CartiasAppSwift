import SwiftUI

struct DownloadProgressView: View {
    @State private var progress: Double = 0.6 // Current progress (99%)
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .leading) {
                // Background Progress View
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                    .scaleEffect(x: 1, y: 4, anchor: .center) // Make the progress bar thicker
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
                                .foregroundColor(.black)
                            
                            Image(systemName: "figure.run.circle.fill")
                                .resizable()
                                .frame(width: iconSize, height: iconSize)
                                .foregroundColor(.black)
                        }
                        .offset(y: -40) // Position icon and text above the progress bar
                        
                        Spacer() // Push the content to the start of the progress
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(height: 50) // Set the height to match the overall height of the progress bar and the icon
        .padding()
    }
}

#Preview {
    DownloadProgressView()
}
