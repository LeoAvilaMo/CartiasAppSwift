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

// Function to convert numeric strings to actual numbers in the JSON
func fixNumericFieldsInJSON(_ data: Data) throws -> Data {
    // Decode the raw JSON as a dictionary first
    if var jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        // Manually convert string fields to numbers
        if let id = jsonDict["ID_EVENTO"] as? String, let idInt = Int(id) {
            jsonDict["ID_EVENTO"] = idInt
        }
        if let maxAsistentes = jsonDict["NUM_MAX_ASISTENTES"] as? String, let maxAsistentesInt = Int(maxAsistentes) {
            jsonDict["NUM_MAX_ASISTENTES"] = maxAsistentesInt
        }
        if let puntaje = jsonDict["PUNTAJE"] as? String, let puntajeInt = Int(puntaje) {
            jsonDict["PUNTAJE"] = puntajeInt
        }

        // Re-encode the modified dictionary back to Data
        return try JSONSerialization.data(withJSONObject: jsonDict, options: [])
    }
    
    // If the data could not be converted, return the original
    return data
}

// Improved fetchEvent function to handle and print specific errors
func fetchEvent(eventID: Int) async throws -> EVENTOS {
    // Construct the URL
    guard let url = URL(string: "https://a00835641.tc2007b.tec.mx:10201/event/\(eventID)") else {
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

                // Set the custom date decoding strategy
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)

                // Fix numeric fields in the JSON if they are strings
                let fixedData = try fixNumericFieldsInJSON(data)

                // Decode the JSON data into the EVENTOS struct
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

// Function to fetch all events
func fetchEvents() async throws -> [EVENTOS] {
    guard let url = URL(string: "https://a00835641.tc2007b.tec.mx:10201/all-events") else {
        throw URLError(.badURL)
    }

    // Fetch the data from the API
    let (data, response) = try await URLSession.shared.data(from: url)

    // Check if the HTTP response is OK (status code 200)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    // Optionally print the raw JSON data for debugging
    if let jsonString = String(data: data, encoding: .utf8) {
        print("Raw JSON Response: \(jsonString)")
    }

    do {
        // Decode the JSON into an array of EVENTOS objects
        let decoder = JSONDecoder()
        let events = try decoder.decode([EVENTOS].self, from: data)
        return events
    } catch {
        // Handle and rethrow decoding errors
        print("Error decoding JSON: \(error)")
        throw error
    }
}

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
