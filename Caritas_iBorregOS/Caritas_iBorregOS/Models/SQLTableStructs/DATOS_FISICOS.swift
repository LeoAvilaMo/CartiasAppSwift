//
//  DATOS_FISICOS.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 08/10/24.
//

import Foundation

public struct DATOS_FISICOS: Codable {
    public var id: Int { ID }
    let ID: Int
    let ID_USUARIO: Int
    let PESO: Float
    let ALTURA: Float
    let IMC: Float
    let GLUCOSA: Float
    let FECHA_ACTUALIZACION: String
    
    init(ID: Int, ID_USUARIO: Int, PESO: Float, ALTURA: Float, IMC: Float, GLUCOSA: Float, FECHA_ACTUALIZACION: String) {
        self.ID = ID
        self.ID_USUARIO = ID_USUARIO
        self.PESO = PESO
        self.ALTURA = ALTURA
        self.IMC = IMC
        self.GLUCOSA = GLUCOSA
        self.FECHA_ACTUALIZACION = FECHA_ACTUALIZACION
    }
}
