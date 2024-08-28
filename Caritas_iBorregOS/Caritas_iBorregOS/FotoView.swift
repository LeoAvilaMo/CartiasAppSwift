//
//  FotoView.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 27/08/24.
//

import SwiftUI

struct FotoView: View {
    var body: some View {
        Image("profilePic")
            .resizable(resizingMode: .stretch)
            .aspectRatio(contentMode: .fit)
            .clipShape(.circle)
    }
}

#Preview {
    FotoView()
}
