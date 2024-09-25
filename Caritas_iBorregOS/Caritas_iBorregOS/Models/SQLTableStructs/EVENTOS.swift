//
//  EVENTOS.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 31/08/24.
//

// ADD DATETIME ATTRIBUTE TO SQL

import Foundation

public struct EVENTOS: Codable, Identifiable {
    public var id: Int { ID_EVENTO }
    let ID_EVENTO: Int
    let NOMBRE: String
    let DESCRIPCION: String
    let NUM_MAX_ASISTENTES: Int
    let PUNTAJE: Int
    let FECHA_EVENTO: Date

    // Decodificamos los datos al incializar objeto de evento
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ID_EVENTO = Int(try container.decode(String.self, forKey: .ID_EVENTO))!
        NOMBRE = try container.decode(String.self, forKey: .NOMBRE)
        DESCRIPCION = try container.decode(String.self, forKey: .DESCRIPCION)
        NUM_MAX_ASISTENTES = Int(try container.decode(String.self, forKey: .NUM_MAX_ASISTENTES))!
        PUNTAJE = Int(try container.decode(String.self, forKey: .PUNTAJE))!
        let dateString = try container.decode(String.self, forKey: .FECHA_EVENTO)
        let dateFormatter = DateFormatter()
        // Formato para la fecha
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .FECHA_EVENTO,
                                                   in: container,
                                                   debugDescription: "La fecha no esta en el formato adecuado.")
        }
        FECHA_EVENTO = date
    }

    // Inicializaodr manual
    init(ID_EVENTO: Int, NOMBRE: String, DESCRIPCION: String, NUM_MAX_ASISTENTES: Int, PUNTAJE: Int, FECHA_EVENTO: Date) {
        self.ID_EVENTO = ID_EVENTO
        self.NOMBRE = NOMBRE
        self.DESCRIPCION = DESCRIPCION
        self.NUM_MAX_ASISTENTES = NUM_MAX_ASISTENTES
        self.PUNTAJE = PUNTAJE
        self.FECHA_EVENTO = FECHA_EVENTO
    }
}
