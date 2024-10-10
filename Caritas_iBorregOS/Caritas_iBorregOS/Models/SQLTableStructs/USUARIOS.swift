    //
//  USUARIOS.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 31/08/24.
//

//
//  Usuario.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 30/08/24.
//
// ADD WEIGHT, HEIGHT AND MENTAL HEALTH

import Foundation

// Define the USUARIOS structure that matches the API response
public struct USUARIOS: Codable {
    let A_MATERNO: String
    let A_PATERNO: String
    let CONTRASENA: String
    let EMAIL: String
    let ID_USUARIO: Int
    let ID_TIPO_USUARIO: Int
    let NOMBRE: String

    //Inicializador manual
    init(ID_USUARIO: Int, NOMBRE: String, A_PATERNO: String, A_MATERNO: String, ID_TIPO_USUARIO: Int, EMAIL: String, CONTRASENA: String) {
        self.ID_USUARIO = ID_USUARIO
        self.NOMBRE = NOMBRE
        self.A_PATERNO = A_PATERNO
        self.A_MATERNO = A_MATERNO
        self.ID_TIPO_USUARIO = ID_TIPO_USUARIO
        self.EMAIL = EMAIL
        self.CONTRASENA = CONTRASENA
    }
}

