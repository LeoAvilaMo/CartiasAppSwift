//
//  RetosViewModel.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 04/10/24.
//

import Foundation


func getAvailableRETOS(userID: Int) -> Array<RETOS>{
    var listRETOS: Array<RETOS> = []
    guard let url = URL(string:"https://jsonplaceholder.typicode.com/posts\(userID)") else{ // Cambiar el link por el indicado
        return listRETOS
    }
    
    let group = DispatchGroup()
    group.enter()
    
    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        let jsonDecoder = JSONDecoder()
        if (data != nil){
            do{
                let retosList = try jsonDecoder.decode([RETOS].self, from: data!)
                for RETO in retosList {
                    print("Id: \(RETO.ID_RETO) - Nombre: \(RETO.NOMBRE) - Descripcion: \(RETO.DESCRIPCION) - Puntaje: \(RETO.PUNTAJE)")
                }
                listRETOS = retosList
            }catch{
                print(error)
            }
        }
        group.leave()
    }
    task.resume()
    group.wait()
    return listRETOS
}

let exampleRETOS = RETOS(ID_RETO: 1, NOMBRE: "RETO SIN NOMBRE 1", DESCRIPCION: "Description", PUNTAJE: 50)
