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
public struct USUARIOS: Codable, Identifiable {
    public var id: Int {ID_USUARIO}
    let ID_USUARIO: Int
    let NOMBRE: String
    let A_PATERNO: String
    let A_MATERNO: String
    let ID_TIPO_USUARIO: Int
    let EMAIL: String
    let CONTRASENA: String
    let PUNTOS: Int
    
    // Custom decoding initializer for JSON
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ID_USUARIO = Int(try container.decode(String.self, forKey: .ID_USUARIO))!
        NOMBRE = try container.decode(String.self, forKey: .NOMBRE)
        A_PATERNO = try container.decode(String.self, forKey: .A_PATERNO)
        A_MATERNO = try container.decode(String.self, forKey: .A_MATERNO)
        ID_TIPO_USUARIO = Int(try container.decode(String.self, forKey: .ID_TIPO_USUARIO))!
        EMAIL = try container.decode(String.self, forKey: .EMAIL)
        CONTRASENA = try container.decode(String.self, forKey: .CONTRASENA)
        PUNTOS = Int(try container.decode(String.self, forKey: .PUNTOS))!
    }
    
    //Inicializador manual
    init(ID_USUARIO: Int, NOMBRE: String, A_PATERNO: String, A_MATERNO: String, ID_TIPO_USUARIO: Int, EMAIL: String, CONTRASENA: String, PUNTOS: Int) {
        self.ID_USUARIO = ID_USUARIO
        self.NOMBRE = NOMBRE
        self.A_PATERNO = A_PATERNO
        self.A_MATERNO = A_MATERNO
        self.ID_TIPO_USUARIO = ID_TIPO_USUARIO
        self.EMAIL = EMAIL
        self.CONTRASENA = CONTRASENA
        self.PUNTOS = PUNTOS
    }
}

