//
//  RETOS.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 31/08/24.
//

import Foundation

public struct RETOS: Codable, Identifiable {
    public var id: Int { ID_RETO }
    let ID_RETO: Int
    let NOMBRE: String
    let DESCRIPCION: String
    let PUNTAJE: Int
    
    init(ID_RETO: Int, NOMBRE: String, DESCRIPCION: String, PUNTAJE: Int) {
        self.ID_RETO = ID_RETO
        self.NOMBRE = NOMBRE
        self.DESCRIPCION = DESCRIPCION
        self.PUNTAJE = PUNTAJE
    }
}
