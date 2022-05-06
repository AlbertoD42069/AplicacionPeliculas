//
//  UserData.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 04/05/22.
//

import Foundation

class UserData {
    
    static let shared = UserData()
    
    var userId:String?
    
    
    init(){}
    
    func isUserLogued() -> Bool {
        guard let id = userId else
        {
            return false
        }
        
        return true
        
    }
}
