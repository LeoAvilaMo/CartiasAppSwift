//
//  VMTienda.swift
//  CaritasApp
//
//  Created by Yolis on 25/09/24.
//

import Foundation

func numeros(_ data: Data) throws -> Data {

    if var jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
    
        if let id = jsonDict["ID_BENEFICIO"] as? String, let idInt = Int(id) {
            jsonDict["ID_BENEFICIO"] = idInt
        }
        if let puntos = jsonDict["PUNTOS"] as? String, let puntajeInt = Int(puntos) {
            jsonDict["PUNTOS"] = puntajeInt
        }

        return try JSONSerialization.data(withJSONObject: jsonDict, options: [])
    }
    return data
}

func fetchBeneficios() async throws -> [BENEFICIOS] {
    guard let url = URL(string: "http://127.0.0.1:10201/all-benefits") else {
        throw URLError(.badURL)
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    if let jsonString = String(data: data, encoding: .utf8) {
        print("Raw JSON Response: \(jsonString)")
    }

    do {
        let decoder = JSONDecoder()
        let benefits = try decoder.decode([BENEFICIOS].self, from: data)
        return benefits
    } catch {
        print("Error decoding JSON: \(error)")
        throw error
    }
}


let exampleBenefit = BENEFICIOS(
    ID_BENEFICIO: 1,
    NOMBRE: "Cafe gratis",
    DESCRIPCION: "oxxo",
    PUNTOS: 10
)
