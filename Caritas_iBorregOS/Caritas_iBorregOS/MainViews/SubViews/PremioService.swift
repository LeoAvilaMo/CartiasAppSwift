//
//  PremioService.swift
//  Caritas_iBorregOS
//
//  Created by Alumno on 03/10/24.
//
import Foundation

class PremioService: ObservableObject {
    @Published var premios: [Premio] = []
    
    func fetchPremios() {
        guard let url = URL(string: "https://a00835641.tc2007b.tec.mx:10201/premios") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al hacer la petición: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
  
            do {
                let premios = try JSONDecoder().decode([Premio].self, from: data)
                DispatchQueue.main.async {
                    self.premios = premios
                }
            } catch {
                print("Error al decodificar los datos: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
