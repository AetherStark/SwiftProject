//
//  reporte.swift
//  SwiftProject
//
//  Created by Francisco on 12/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import Foundation

class Reporte	 {
    
    var idreporte: String?
    var ubicacion: String?
    var latitud: String?
    var longitud: String?
    var fecha: String?
    var descripcion: String?
    var titulo: String?
    var puntuacion: String?
   
    
    init(idrep: String?, ubi: String?, lat: String?,long: String?,fecha: String?,descrip: String?,titulo: String?,puntuacion: String?) {
        self.idreporte  = idrep
        self.ubicacion = ubi
        self.latitud = lat
        self.longitud = long
        self.fecha = fecha
        self.descripcion = descrip
        self.titulo = titulo
        self.puntuacion = puntuacion
  
    }
}
