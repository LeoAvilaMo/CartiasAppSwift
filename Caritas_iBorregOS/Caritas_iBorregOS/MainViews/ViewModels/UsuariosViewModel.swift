//
//  UsuariosViewModel.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 25/09/24.
//

import Foundation

// Function to convert numeric strings to actual numbers in the JSON
func fixNumericFieldsInJSONUser(_ data: Data) throws -> Data {
    // Decode the raw JSON as a dictionary first
    if var jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        // Manually convert string fields to numbers
        if let id = jsonDict["ID_USUARIO"] as? String, let idInt = Int(id) {
            jsonDict["ID_USUARIO"] = idInt
        }
        if let nombreUsuario = jsonDict["NOMBRE"] as? String {
                    jsonDict["NOMBRE"] = nombreUsuario
        }
        if let apellidoPaterno = jsonDict["A_PATERNO"] as? String {
            jsonDict["A_PATERNO"] = apellidoPaterno
        }
        if let apellidoMaterno = jsonDict["A_MATERNO"] as? String {
            jsonDict["A_MATERNO"] = apellidoMaterno
        }

        // Re-encode the modified dictionary back to Data
        return try JSONSerialization.data(withJSONObject: jsonDict, options: [])
    }
    
    // If the data could not be converted, return the original
    return data
}

// Improved fetchEvent function to handle and print specific errors
func fetchUsuario(usuarioID: Int) async throws -> USUARIOS {
    // Construct the URL
    guard let url = URL(string: "https://a00835641.tc2007b.tec.mx:10201/usuario/\(usuarioID)") else {
        throw APIError.invalidURL
    }
    
    // Perform the request asynchronously
    let (data, response) = try await URLSession.shared.data(from: url)
    
    // Check for the HTTP status code
    if let httpResponse = response as? HTTPURLResponse {
        switch httpResponse.statusCode {
        case 200:
            do {
                let decoder = JSONDecoder()
                // Fix numeric fields in the JSON if they are strings
                let fixedData = try fixNumericFieldsInJSON(data)

                // Decode the JSON data into the EVENTOS struct
                let usuario = try decoder.decode(USUARIOS.self, from: fixedData)
                return usuario
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
                throw APIError.decodingFailed
            }

        case 404:
            print("Error: Event not found")
            throw APIError.eventNotFound

        case 500:
            print("Error: Server error")
            if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
               let errorMessage = errorResponse["error"] {
                throw APIError.serverError(errorMessage)
            } else {
                throw APIError.serverError("Unknown server error")
            }

        default:
            print("Error: Request failed with status code: \(httpResponse.statusCode)")
            throw APIError.requestFailed
        }
    } else {
        print("Error: Invalid response")
        throw APIError.requestFailed
    }
}

let exampleUsuario = USUARIOS(
    ID_USUARIO: 1,
    NOMBRE: "Trysha",
    A_PATERNO: "Paytas",
    A_MATERNO: "Garza",
    ID_TIPO_USUARIO: 1,
    EMAIL: "trishagarza@gmail.com",
    CONTRASENA: "example123",
    PUNTOS: 50
)
