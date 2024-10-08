//
//  DatosFisicosViewModel.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 08/10/24.
//

import Foundation

func getDatosFisicos(userID: Int) -> Array<DATOS_FISICOS>{
    var listDatosFisicos: Array<DATOS_FISICOS> = []
    guard let url = URL(string:"\(urlEndpoint)/usuario/\(userID)/datos-fisicos") else{ // Cambiar el link por el indicado
        return listDatosFisicos
    }
    
    let group = DispatchGroup()
    group.enter()
    
    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        let jsonDecoder = JSONDecoder()
        if (data != nil){
            do{
                let datosFisicosList = try jsonDecoder.decode([DATOS_FISICOS].self, from: data!)
                for DATO_FISICO in datosFisicosList {
                    print("Id: \(DATO_FISICO.ID) - IdUsuario: \(DATO_FISICO.ID_USUARIO) - Peso: \(DATO_FISICO.PESO) - Altura: \(DATO_FISICO.ALTURA) - IMC: \(DATO_FISICO.IMC) - Glucosa: \(DATO_FISICO.GLUCOSA) - FechaActualizacion: \(DATO_FISICO.FECHA_ACTUALIZACION)")
                }
                listDatosFisicos = datosFisicosList
            }catch{
                print(error)
            }
        }
        group.leave()
    }
    task.resume()
    group.wait()
    return listDatosFisicos
}

let exampleDATO_FISICO = DATOS_FISICOS(ID: 1, ID_USUARIO: 1, PESO: 1, ALTURA: 1, IMC: 1, GLUCOSA: 1, FECHA_ACTUALIZACION: "2024-10-10 08:30:00")
