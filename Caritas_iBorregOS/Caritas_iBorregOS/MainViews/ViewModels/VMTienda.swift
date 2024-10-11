import Foundation
import SwiftUI

// Estructura para manejar los datos que se envían en el canje del beneficio
struct RedeemRequest: Codable {
    let usuario_id: Int
    let beneficio_id: Int
}

public class VMTienda: ObservableObject {
    @Published var beneficios: [BENEFICIOS] = []
    @Published var usuario: USUARIOS?
    @Published var errorMessage: String?
    @Published var currentBenefitDescription: String?
    @Published var puntosUsuario: Int = 0
    @Published var responseMessage: String? // Se utilizaba como String? pero se esperaba como String
    
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
        guard let url = URL(string: "\(urlEndpoint)/all-benefits") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.requestFailed
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
            throw APIError.decodingFailed
        }
    }
    
    func redeemBenefit(usuarioID: Int, beneficioID: Int) async throws -> String {
        guard let url = URL(string: "\(urlEndpoint)/redeem-benefit") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let redeemData = RedeemRequest(usuario_id: usuarioID, beneficio_id: beneficioID)
        
        do {
            let jsonData = try JSONEncoder().encode(redeemData)
            // Enviar solicitud POST con los datos de canje
            let (data, response) = try await URLSession.shared.upload(for: request, from: jsonData)
            // Validar la respuesta del servidor
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed
            }
            
            switch httpResponse.statusCode {
            case 201:
                // Si se recibe un 201, procesar la respuesta
                let adjustedData = try numeros(data)
                if let jsonString = String(data: adjustedData, encoding: .utf8) {
                    print("Response from server: \(jsonString)")
                    return "Beneficio canjeado exitosamente."
                }
            case 400:
                return "Datos de entrada inválidos."
            case 404:
                return "Beneficio no encontrado o puntos insuficientes."
            default:
                return "Error del servidor. Código de estado: \(httpResponse.statusCode)."
            }
        } catch {
            print("Error al canjear el beneficio: \(error.localizedDescription)")
            throw error
        }
        return "Error inesperado."
    }
}

let exampleBenefit = BENEFICIOS(
    ID_BENEFICIO: 1,
    NOMBRE: "Cafe gratis",
    DESCRIPCION: "oxxo",
    PUNTOS: 10
)
