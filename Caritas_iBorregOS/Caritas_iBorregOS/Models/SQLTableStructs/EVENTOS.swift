//
//  EVENTOS.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 31/08/24.
//

// ADD DATETIME ATTRIBUTE TO SQL

import Foundation

public struct EVENTOS: Codable {
    let ID_EVENTO: Int
    let NOMBRE: String
    let DESCRIPCION: String
    let NUM_MAX_ASISTENTES: Int
    let PUNTAJE: Int
}
