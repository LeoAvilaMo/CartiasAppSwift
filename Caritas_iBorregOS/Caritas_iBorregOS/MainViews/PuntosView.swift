//
//  PuntosView.swift
//  Caritas_iBorregOS
//
//  Created by Diego Torre on 09/10/24.
//

import SwiftUI

struct PuntosView: View {
    @State private var totalPoints: String?

        var body: some View {
            VStack {
                if let points = totalPoints {
                    Text("Total Points: \(points)")
                } else {
                    Text("Fetching points...")
                }
                Button("Fetch User Points") {
                    Task {
                        await fetchPoints()
                    }
                }
            }
        }

        func fetchPoints() async {
            do {
                let userPoints = try await fetchUserTotalPoints(for: 1)
                totalPoints = userPoints.totalPoints
            } catch {
                print("Failed to fetch user total points: \(error)")
            }
        }
    }

#Preview {
    PuntosView()
}
