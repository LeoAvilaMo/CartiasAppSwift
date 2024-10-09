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

// Define the response structure
struct AttendanceResponse: Codable {
    let asistio: Bool?
    let error: String?
}

struct AttendanceRequest: Codable {
    let usuario_id: Int
    let evento_id: Int
    let event_name: String
    let event_code: String
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
    guard let url = URL(string: "\(urlEndpoint)/event/\(eventID)") else {
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
    guard let url = URL(string: "\(urlEndpoint)/all-events") else {
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

func checkAttendance(usuarioID: Int, eventoID: Int) async throws -> Bool? {
    let urlString = "\(urlEndpoint)/get-attendance-events/\(usuarioID)/\(eventoID)"
    print("Attempting to fetch attendance with URL: \(urlString)")  // Print the URL
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        print("Received data: \(String(data: data, encoding: .utf8) ?? "No data")")  // Print raw data
        
        let attendanceResponse = try JSONDecoder().decode(AttendanceResponse.self, from: data)
        print("Decoded response: \(attendanceResponse)")

        // Return the value of 'asistio', or nil if the user is not registered
        if let asistio = attendanceResponse.asistio {
            print("User attendance status: \(asistio)")
            return asistio
        } else if let errorMessage = attendanceResponse.error, errorMessage == "Not registered" {
            print("User is not registered")
            return nil  // User is not registered, so return nil
        } else {
            throw URLError(.badServerResponse)
        }
    } catch {
        print("Error fetching attendance: \(error.localizedDescription)")
        throw error
    }
}

func registerAttendance(usuarioID: Int, eventoID: Int) async throws -> Bool {
    let urlString = "\(urlEndpoint)/register-event-attendance"
    print("Attempting to register attendance with URL: \(urlString)")  // Print the URL
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    // Prepare the request body
    let requestBody: [String: Any] = [
        "usuario_id": usuarioID,
        "evento_id": eventoID
    ]
    
    // Serialize the request body to JSON data
    let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])

    // Prepare the URL request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData

    // Execute the network request
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check the HTTP response status
        guard let httpResponse = response as? HTTPURLResponse else {
            print("No valid response from the server.")
            throw URLError(.badServerResponse)
        }
        
        // Handle different HTTP status codes
        switch httpResponse.statusCode {
        case 201:
            print("Attendance registered successfully.")
            return true
        case 200:
            print("User already registered for this event.")
            return false  // User is already registered
        default:
            print("Failed to register attendance. Server response: \(httpResponse.statusCode)")
            throw URLError(.badServerResponse)
        }
        
    } catch {
        print("Error during registration: \(error.localizedDescription)")
        throw error
    }
}

func registerEventCompletion(attendance: AttendanceRequest, completion: @escaping (Result<String, Error>) -> Void) {
    // Create the URL
    guard let url = URL(string: "\(urlEndpoint)/register-event-completion") else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    
    // Create the request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Encode the attendance request to JSON
    do {
        let jsonData = try JSONEncoder().encode(attendance)
        request.httpBody = jsonData
    } catch {
        completion(.failure(error))
        return
    }
    
    // Perform the request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // Handle network or other errors
        if let error = error {
            completion(.failure(error))
            return
        }
        
        // Ensure we received a proper response
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
            return
        }
        
        // Handle the different status codes from the API
        switch httpResponse.statusCode {
        case 200, 201:
            completion(.success("Attendance registered successfully"))
        case 400:
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid input data or event code"])))
        case 404:
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Event not found"])))
        default:
            completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])))
        }
    }
    
    task.resume()  // Start the request
}

let exampleEvent = EVENTOS(
    ID_EVENTO: 1,
    NOMBRE: "Yoga en el parque Rufino Tamayo",
    DESCRIPCION: "Una clase de yoga en el parque.",
    NUM_MAX_ASISTENTES: 50,
    PUNTAJE: 10,
    FECHA_EVENTO: Date(timeIntervalSince1970: 1700793600) 
)
