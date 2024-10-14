//
//  ChartView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 08/10/24.
//
import SwiftUI
import Charts

struct ChartView: View {
    
    public var graphDataX: [Float] = [10.5, 11.5, 12.5, 10.5, 16.5]
    public var graphDataY: [String] = ["2024-10-08 16:48:45.773000", "2024-10-09 16:48:45.873000", "2024-10-10 16:48:45.973000", "2024-10-11 16:48:45.1073000", "2024-10-12 16:48:45.1173000"]
    public var unitsX: String = "kg"
    public var graphTitleX: String = "Peso 🍏"
    public var chartColorX: Color = Color(red: 161/255, green: 90/255, blue: 149/255)
    var body: some View {
        VStack(alignment: .leading) {
            Text(graphTitleX)
                .font(.title)
                .bold()
                .foregroundStyle(chartColorX)
            
            Chart {
                ForEach(0..<graphDataY.count, id: \.self) { i in
                    BarMark(
                        x: .value("Mes", formatDateString(graphDataY[i])),  // Using formatted date
                        y: .value("Peso", graphDataX[i])
                    )
                    .foregroundStyle(chartColorX)
                    .annotation(position: .top) {
                        Text("\(graphDataX[i], specifier: "%.1f") \(unitsX)")
                            .foregroundStyle(chartColorX)
                            .font(.system(size: 10))
                    }
                }
            }
            .chartYAxis {
                AxisMarks(stroke: StrokeStyle(lineWidth: 0))
            }
            .chartXAxis {
                AxisMarks(stroke: StrokeStyle(lineWidth: 0))
            }
            .frame(height: 200)
            .padding()
        }
        .padding()
        .background(chartColorX.brightness(0.5).opacity(0.85))
        .cornerRadius(10)
    }
    
    // Function to convert date string to "MMM dd" format and trim the string before "SSSSSS"
    func formatDateString(_ dateString: String) -> String {
        // Extract up to the seconds portion only (ignore microseconds)
        let trimmedDateString = String(dateString.prefix(19))  // "yyyy-MM-dd HH:mm:ss"
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // Input format without microseconds
        
        if let date = inputFormatter.date(from: trimmedDateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM dd"  // Output format (e.g., "Oct 08")
            return outputFormatter.string(from: date)
        } else {
            return dateString  // Return the original string if parsing fails
        }
    }
}

#Preview {
    ChartView(graphDataX: [10.5, 11.5, 12.5, 10.5, 16.5], graphDataY: ["2024-10-08 16:48:45.773000", "2024-10-09 16:48:45.873000", "2024-10-10 16:48:45.973000", "2024-10-11 16:48:45.1073000", "2024-10-12 16:48:45.1173000"], unitsX: "kg", graphTitleX: "Peso 🍎", chartColorX: Color(red: 161/255, green: 90/255, blue: 149/255))
}
