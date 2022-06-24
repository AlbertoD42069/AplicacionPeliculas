//
//  Fecha.swift
//  Peliculas
//
//  Created by Hector Guadalupe Climaco Flores on 23/06/22.
//

import Foundation

class Fecha {
    
    func fecha () {
        var fecha = Date()
        let formatoFecha = DateFormatter()
        formatoFecha.dateStyle = .short
        print("la fecha es \(formatoFecha.string(from: fecha))")}
}
