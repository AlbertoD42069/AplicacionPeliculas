//
//  StrucPeliculas.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 05/05/22.
//

import Foundation
import UIKit

struct Movies: Decodable{
    //var page:Int
    var results:[Movie]
}

struct Movie: Decodable{
    var id:Int
    var vote_average:Double
    var original_title:String?
    var name:String?
    var release_date:String?
    var poster_path:String
    var overview:String
    var first_air_date: String?
    //var original_language:String
}
