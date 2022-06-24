//
//  UserData.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 04/05/22.
//

import Foundation

class UserData {
    
    static let shared = UserData()
    
    var userEmail:String?
    
    
    init(){}
    
    func isUserLogued() -> Bool {
        guard let Email = userEmail else
        {
            return false
        }
        
        return true
        
    }
}
