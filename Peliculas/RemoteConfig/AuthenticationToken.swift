//
//  AuthenticationToken.swift
//  Peliculas
//
//  Created by Hector Guadalupe Climaco Flores on 21/06/22.
//

import Foundation
import FirebaseInstallations

class AuthenticationToken{
    func validarToken(){
        Installations.installations().authTokenForcingRefresh(true, completion: { (result, error) in
          if let error = error {
            print("Error fetching token: \(error)")
            return
          }
          guard let result = result else { return }
          print("Installation auth token: \(result.authToken)")
        })
    }
}
