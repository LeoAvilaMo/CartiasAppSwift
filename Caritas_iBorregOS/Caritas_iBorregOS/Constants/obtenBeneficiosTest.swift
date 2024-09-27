//
//  obtenBeneficiosTest.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 31/08/24.
//

import Foundation

var listaBeneficios = obtenBeneficiosTest()

func obtenBeneficiosTest() -> Array<BENEFICIOS> {
    let listaBeneficios = [
        BENEFICIOS(ID_BENEFICIO: 1, NOMBRE: "AirPods Pro MAX", DESCRIPCION: "Son Bluetooth", PUNTOS: 1000),
        BENEFICIOS(ID_BENEFICIO: 2, NOMBRE: "3 Noches de hotel en Chipinque", DESCRIPCION: "Muy alto", PUNTOS: 5000),
        BENEFICIOS(ID_BENEFICIO: 3, NOMBRE: "2 Boletos en Cinmex sala VIP", DESCRIPCION: "Película", PUNTOS: 100),
        BENEFICIOS(ID_BENEFICIO: 4, NOMBRE: "Día libre", DESCRIPCION: "Diviértete", PUNTOS: 500),
        BENEFICIOS(ID_BENEFICIO: 5, NOMBRE: "Sándwich de 15 cm de Subway", DESCRIPCION: "Un sándwich", PUNTOS: 50)
    ]
    return listaBeneficios
}
