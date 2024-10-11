import SwiftUI

struct BeneficioCardView: View {
    
    let blueC = Color(red: 0/255, green: 156/255, blue: 166/255)
    let darkBlueC = Color(red: 0/255, green: 59/255, blue: 92/255)
    let whiteC = Color(red: 255/255, green: 255/255, blue: 255/255)
    let whiteMateC = Color(red: 253/255, green: 251/255, blue: 249/255)
    let orangeC = Color(red: 255/255, green: 127/255, blue: 50/255)
    
    // Placeholder
    public var beneficioX: BENEFICIOS
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "gift.fill")
                    .resizable()
                    .foregroundStyle(blueC)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .scaledToFit()
                    .padding(.leading, 10)
                    .padding(.top)
                
                Text(beneficioX.NOMBRE)
                    .font(.system(size: 25))
                    .bold()
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            HStack {
                HStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .foregroundStyle(.yellow)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                        .padding(.leading, 20)
                    
                    Text(String(beneficioX.PUNTOS))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(blueC)
                }
                
                Spacer()
                
                // NavigationLink wrapping the button
                NavigationLink(destination: BeneficioDetailView(beneficioX: beneficioX)) {
                    HStack {
                        Image(systemName: "arrow.down.right.square.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(orangeC)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 8)
                }
            }
        }
        .background(.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

#Preview {
        var placeholderBeneficioX = BENEFICIOS(ID_BENEFICIO: 1, NOMBRE: "UN BENEFICIO", DESCRIPCION: "UNA DESCRIPCIÓN", PUNTOS: 10000)
        BeneficioCardView(beneficioX: placeholderBeneficioX)
}
