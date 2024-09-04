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
        BENEFICIOS(id: 1, NOMBRE: "AirPods Pro MAX", DESCRIPCION: "Son Bluetooth", PUNTOS: 1000, ICONO: "headphones"),
        BENEFICIOS(id: 2, NOMBRE: "3 Noches de hotel en Chipinque", DESCRIPCION: "Muy alto", PUNTOS: 5000, ICONO: "mountain.2.fill"),
        BENEFICIOS(id: 3, NOMBRE: "2 Boletos en Cinmex sala VIP", DESCRIPCION: "Película", PUNTOS: 100, ICONO: "ticket.fill"),
        BENEFICIOS(id: 4, NOMBRE: "Día libre", DESCRIPCION: "Diviértete", PUNTOS: 500, ICONO: "bed.double.fill"),
        BENEFICIOS(id: 5, NOMBRE: "Sándwich de 15 cm de Subway", DESCRIPCION: "Un sándwich", PUNTOS: 50, ICONO: "fork.knife")
    ]
    return listaBeneficios
}
