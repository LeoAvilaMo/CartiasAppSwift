//
//  PesoEnMesesData.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 28/08/24.
//

import Foundation

struct PesoPorMes: Identifiable{
    var id = UUID().uuidString
    var month: String
    var weight: Double
}
