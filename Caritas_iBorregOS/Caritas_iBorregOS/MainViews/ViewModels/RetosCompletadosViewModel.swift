//
//  RetosCompletadosViewModel.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 08/10/24.
//

import Foundation

// Decodify un solo item
func getRetosCompletados(usuarioID: Int) -> RetosCompletados {
    var localRetosCompletados = RetosCompletados(CompletedRetos: 1, TotalRetos: 1)
    guard let url = URL(string:"\(urlEndpoint)/usuario/\(usuarioID)/retos") else{
        return localRetosCompletados
       }
       
       let group = DispatchGroup()
       group.enter()
       
       let task = URLSession.shared.dataTask(with: url){
           data, response, error in
           
           let jsonDecoder = JSONDecoder()
           if (data != nil){
               do{
                   let retosCompletadosItem = try jsonDecoder.decode(RetosCompletados.self, from: data!)
                   print("Rets Completados: \(retosCompletadosItem.CompletedRetos) \nTotal Retos: \(retosCompletadosItem.TotalRetos) ")
                   localRetosCompletados = RetosCompletados(CompletedRetos: retosCompletadosItem.CompletedRetos, TotalRetos: retosCompletadosItem.TotalRetos)
               }catch{
                   print(error)
               }
           }
           group.leave()
       }
       task.resume()
       group.wait()
       return localRetosCompletados
   }


let exampleRetosCompletados = RetosCompletados(CompletedRetos: 1, TotalRetos: 1)
