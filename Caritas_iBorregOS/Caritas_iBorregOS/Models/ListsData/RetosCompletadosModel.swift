//
//  RetosCompletadosModel.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 08/10/24.
//

import Foundation

public struct RetosCompletados: Codable {
    public var CompletedRetos: Int
    public var TotalRetos: Int
    
    init(CompletedRetos: Int, TotalRetos: Int) {
        self.CompletedRetos = CompletedRetos
        self.TotalRetos = TotalRetos
    }
}
