//
//  PremioService.swift
//  Caritas_iBorregOS
//
//  Created by Alumno on 03/10/24.
//
import Foundation



func getPremiosNoUsados(userID: Int) -> Array<PREMIO>{
    var listPREMIOS: Array<PREMIO> = []
    guard let url = URL(string:"\(urlEndpoint)/user/\(userID)/unclaimedpremios") else{ // Cambiar el link por el indicado
        return listPREMIOS
    }
    
    let group = DispatchGroup()
    group.enter()
    
    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        let jsonDecoder = JSONDecoder()
        if (data != nil){
            do{
                let premiosList = try jsonDecoder.decode([PREMIO].self, from: data!)
                for premio in premiosList {
                    print("Id: \(premio.ID_BENEFICIO) - Nombre: \(premio.NOMBRE) - Descripcion: \(premio.DESCRIPCION) - Puntaje: \(premio.PUNTOS)")
                }
                listPREMIOS = premiosList
            }catch{
                print(error)
            }
        }
        group.leave()
    }
    task.resume()
    group.wait()
    return listPREMIOS
}
