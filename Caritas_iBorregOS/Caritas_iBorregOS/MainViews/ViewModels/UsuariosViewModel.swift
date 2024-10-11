//
//  UsuariosViewModel.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 25/09/24.
//

import Foundation


// Decodify un solo item
func getUsuario(email: String) -> USUARIOS {
    var localUsuario = USUARIOS(ID_USUARIO: 1, NOMBRE: "", A_PATERNO: "", A_MATERNO: "", ID_TIPO_USUARIO: 1, EMAIL: "", CONTRASENA: "")
    guard let url = URL(string:"\(urlEndpoint)/usuario/\(email)") else{
        return localUsuario
       }
       
       let group = DispatchGroup()
       group.enter()
       
       let task = URLSession.shared.dataTask(with: url){
           data, response, error in
           
           let jsonDecoder = JSONDecoder()
           if (data != nil){
               do{
                   let usuarioItem = try jsonDecoder.decode(USUARIOS.self, from: data!)
                   print("ID: \(usuarioItem.ID_USUARIO) \nNombre: \(usuarioItem.NOMBRE) \nApellidoP: \(usuarioItem.A_PATERNO) \nApellidoM: \(usuarioItem.A_MATERNO) \nTipoUsuario: \(usuarioItem.ID_TIPO_USUARIO) \nEmail: \(usuarioItem.EMAIL) \nContrasena: \(usuarioItem.CONTRASENA)")
                   localUsuario = USUARIOS(ID_USUARIO: usuarioItem.ID_USUARIO, NOMBRE: usuarioItem.NOMBRE, A_PATERNO: usuarioItem.A_PATERNO, A_MATERNO: usuarioItem.A_MATERNO, ID_TIPO_USUARIO: usuarioItem.ID_TIPO_USUARIO, EMAIL: usuarioItem.EMAIL, CONTRASENA: usuarioItem.CONTRASENA)
               }catch{
                   print(error)
               }
           }
           group.leave()
       }
       task.resume()
       group.wait()
       return localUsuario
   }
// Define the UserTotalPoints model to decode API response
struct UserTotalPoints: Codable {
    let totalBenefitPointsSpent: String
    let totalEventPoints: String
    let totalPoints: String
    let totalRetoPoints: String

    enum CodingKeys: String, CodingKey {
        case totalBenefitPointsSpent = "TotalBenefitPointsSpent"
        case totalEventPoints = "TotalEventPoints"
        case totalPoints = "TotalPoints"
        case totalRetoPoints = "TotalRetoPoints"
    }
}

// Asynchronous function to fetch user total points from the API
func fetchUserTotalPoints(for userID: Int) async throws -> Int {
    // Construct the API URL dynamically with userID
    guard let url = URL(string: "\(urlEndpoint)/user/\(userID)/total-points") else {
        throw URLError(.badURL)
    }

    print("Fetching data from URL: \(url)")

    do {
        // Perform the network request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Ensure the response is a 200 OK
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("HTTP Status Code: \(httpResponse.statusCode)")

        // Print raw JSON response to check data
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON Response: \(jsonString)")
        }

        guard httpResponse.statusCode == 200 else {
            print("Error: Server returned status code \(httpResponse.statusCode)")
            throw URLError(.badServerResponse)
        }

        // Decode the JSON response into a dictionary with a String value for "TotalPoints"
        let decodedData = try JSONDecoder().decode([String: String].self, from: data)

        // Ensure the key "TotalPoints" exists in the response and convert it to Int
        guard let totalPointsString = decodedData["TotalPoints"],
              let totalPoints = Int(totalPointsString) else {
            throw URLError(.cannotDecodeRawData)
        }
        
        // Print the user's total points
        print("Total Points: \(totalPoints)")

        return totalPoints

    } catch {
        // Handle decoding errors
        print("Error occurred during network request or JSON decoding: \(error)")
        throw error
    }
}



let exampleUsuario = USUARIOS(
    ID_USUARIO: 1,
    NOMBRE: "Trysha",
    A_PATERNO: "Paytas",
    A_MATERNO: "Garza",
    ID_TIPO_USUARIO: 1,
    EMAIL: "trishagarza@gmail.com",
    CONTRASENA: "example123"
)
