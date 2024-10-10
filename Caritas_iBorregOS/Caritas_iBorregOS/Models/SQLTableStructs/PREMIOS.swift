//
//  PREMIOS.swift
//  Caritas_iBorregOS
//
//  Created by Alumno on 09/10/24.
//
import Foundation


struct PREMIOS: Codable, Identifiable {
    let ID_PREMIOS: Int
    let NOMBRE: String
    let DESCRIPCION: String
    
    var id: Int {
        return ID_PREMIOS
    }

    // Inicializador
    init(ID_PREMIOS: Int, NOMBRE: String, DESCRIPCION: String) {
        self.ID_PREMIOS = ID_PREMIOS
        self.NOMBRE = NOMBRE
        self.DESCRIPCION = DESCRIPCION
    }
}



