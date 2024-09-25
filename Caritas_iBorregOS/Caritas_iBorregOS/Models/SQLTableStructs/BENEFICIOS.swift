//
//  BENEFICIOS.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 31/08/24.
//

import Foundation

public struct BENEFICIOS : Identifiable, Codable{
    public var id: Int
    var NOMBRE: String
    var DESCRIPCION: String
    var PUNTOS: Int
    var ICONO: String
    
    init(id: Int, NOMBRE: String, DESCRIPCION: String, PUNTOS: Int, ICONO: String) {
        self.id = id
        self.NOMBRE = NOMBRE
        self.DESCRIPCION = DESCRIPCION
        self.PUNTOS = PUNTOS
        self.ICONO = ICONO
    }
}
