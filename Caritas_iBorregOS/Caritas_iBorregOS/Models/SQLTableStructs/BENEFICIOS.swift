//
//  BENEFICIOS.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 31/08/24.
//

import Foundation

public struct BENEFICIOS: Codable, Identifiable {
    public var id: Int { ID_BENEFICIO}
    let ID_BENEFICIO: Int
    let NOMBRE: String
    let DESCRIPCION: String
    let PUNTOS: Int

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ID_BENEFICIO = Int(try container.decode(String.self, forKey: .ID_BENEFICIO))!
        NOMBRE = try container.decode(String.self, forKey: .NOMBRE)
        DESCRIPCION = try container.decode(String.self, forKey: .DESCRIPCION)
        PUNTOS = Int(try container.decode(String.self, forKey: .PUNTOS))!
    }

    init(ID_BENEFICIO: Int, NOMBRE: String, DESCRIPCION: String, PUNTOS: Int) {
        self.ID_BENEFICIO = ID_BENEFICIO
        self.NOMBRE = NOMBRE
        self.DESCRIPCION = DESCRIPCION
        self.PUNTOS = PUNTOS
    }
}
