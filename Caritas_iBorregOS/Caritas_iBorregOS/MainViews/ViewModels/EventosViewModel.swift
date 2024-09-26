//
//  EventosViewModel.swift
//  Caritas_iBorregOS
//
//  Created by Diego Torre on 24/09/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case eventNotFound
    case serverError(String)
}

import Foundation

// Convertir valores numericos del evento a string para renderizar
func fixNumericFieldsInJSON(_ data: Data) throws -> Data {

    if var jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
    
        if let id = jsonDict["ID_EVENTO"] as? String, let idInt = Int(id) {
            jsonDict["ID_EVENTO"] = idInt
        }
        if let maxAsistentes = jsonDict["NUM_MAX_ASISTENTES"] as? String, let maxAsistentesInt = Int(maxAsistentes) {
            jsonDict["NUM_MAX_ASISTENTES"] = maxAsistentesInt
        }
        if let puntaje = jsonDict["PUNTAJE"] as? String, let puntajeInt = Int(puntaje) {
            jsonDict["PUNTAJE"] = puntajeInt
        }

        
        return try JSONSerialization.data(withJSONObject: jsonDict, options: [])
    }
    
    // En caso de tener error, regresar datos originales
    return data
}

// Funcion para manejar ruta que obtiene un evento individual
func fetchEvent(eventID: Int) async throws -> EVENTOS {
    // Construct the URL
    guard let url = URL(string: "https://a00835641.tc2007b.tec.mx:10201/event/\(eventID)") else {
        throw APIError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    if let httpResponse = response as? HTTPURLResponse {
        switch httpResponse.statusCode {
        case 200:
            do {
                let decoder = JSONDecoder()

                // Formato de fecha como buscamos
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)

                // Cambiar valores numericos a strings
                let fixedData = try fixNumericFieldsInJSON(data)

                // Decodificar a la estrucutra eventos
                let event = try decoder.decode(EVENTOS.self, from: fixedData)
                return event
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

// Funcion que obtiene todos los eventos
func fetchEvents() async throws -> [EVENTOS] {
    guard let url = URL(string: "https://a00835641.tc2007b.tec.mx:10201/all-events") else {
        throw URLError(.badURL)
    }

    // Llamada asincrona
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    // Hacer print para ver los datos como fueron obtenidos
    if let jsonString = String(data: data, encoding: .utf8) {
        print("Raw JSON Response: \(jsonString)")
    }

    do {
        // Construir arreglo de objetos EVENTO
        let decoder = JSONDecoder()
        let events = try decoder.decode([EVENTOS].self, from: data)
        return events
    } catch {
        // Manejar errores
        print("Error decoding JSON: \(error)")
        throw error
    }
}

// Cambiar fecha a spanish
func dateToStringEs(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale(identifier: "es_ES") 
    
    return dateFormatter.string(from: date)
}

// Formato de fecha adecuado
func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }

let exampleEvent = EVENTOS(
    ID_EVENTO: 1,
    NOMBRE: "Yoga en el parque Rufino Tamayo",
    DESCRIPCION: "Una clase de yoga en el parque.",
    NUM_MAX_ASISTENTES: 50,
    PUNTAJE: 10,
    FECHA_EVENTO: Date(timeIntervalSince1970: 1700793600) 
)
