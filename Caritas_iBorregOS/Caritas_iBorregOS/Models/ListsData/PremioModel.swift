//
//  PremioModel.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 10/10/24.
//

import Foundation

// Obtener los beneficios comprados por el usuario


struct PREMIO:  Codable {
    let ID_BENEFICIO: Int
    let NOMBRE: String
    let DESCRIPCION: String
    let PUNTOS: Int
    
    init(ID_BENEFICIO: Int, NOMBRE: String, DESCRIPCION: String, PUNTOS: Int){
        self.ID_BENEFICIO = ID_BENEFICIO
        self.NOMBRE = NOMBRE
        self.DESCRIPCION = DESCRIPCION
        self.PUNTOS = PUNTOS
    }
}
