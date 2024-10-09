//
//  UsuariosViewModel.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 25/09/24.
//

import Foundation


// Decodify un solo item
func getUsuario(email: String) -> USUARIOS {
    var localUsuario = USUARIOS(ID_USUARIO: 1, NOMBRE: "", A_PATERNO: "", A_MATERNO: "", ID_TIPO_USUARIO: 1, EMAIL: "", CONTRASENA: "")
    guard let url = URL(string:"\(urlEndpoint)/usuario/\(email)") else{
        return localUsuario
       }
       
       let group = DispatchGroup()
       group.enter()
       
       let task = URLSession.shared.dataTask(with: url){
           data, response, error in
           
           let jsonDecoder = JSONDecoder()
           if (data != nil){
               do{
                   let usuarioItem = try jsonDecoder.decode(USUARIOS.self, from: data!)
                   print("ID: \(usuarioItem.ID_USUARIO) \nNombre: \(usuarioItem.NOMBRE) \nApellidoP: \(usuarioItem.A_PATERNO) \nApellidoM: \(usuarioItem.A_MATERNO) \nTipoUsuario: \(usuarioItem.ID_TIPO_USUARIO) \nEmail: \(usuarioItem.EMAIL) \nContrasena: \(usuarioItem.CONTRASENA)")
                   localUsuario = USUARIOS(ID_USUARIO: usuarioItem.ID_USUARIO, NOMBRE: usuarioItem.NOMBRE, A_PATERNO: usuarioItem.A_PATERNO, A_MATERNO: usuarioItem.A_MATERNO, ID_TIPO_USUARIO: usuarioItem.ID_TIPO_USUARIO, EMAIL: usuarioItem.EMAIL, CONTRASENA: usuarioItem.CONTRASENA)
               }catch{
                   print(error)
               }
           }
           group.leave()
       }
       task.resume()
       group.wait()
       return localUsuario
   }


let exampleUsuario = USUARIOS(
    ID_USUARIO: 1,
    NOMBRE: "Trysha",
    A_PATERNO: "Paytas",
    A_MATERNO: "Garza",
    ID_TIPO_USUARIO: 1,
    EMAIL: "trishagarza@gmail.com",
    CONTRASENA: "example123"
)
