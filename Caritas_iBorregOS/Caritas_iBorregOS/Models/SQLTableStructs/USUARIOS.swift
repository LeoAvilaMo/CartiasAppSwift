//
//  USUARIOS.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 31/08/24.
//

import Foundation

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
    let ID_USUARIO: Int
    let NOMBRE: String
    let A_PATERNO: String
    let A_MATERNO: String
    let ID_TIPO_USUARIO: Int

}
