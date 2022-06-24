//
//  ViewControllerPresenter.swift
//  Peliculas
//
//  Created by Hector Guadalupe Climaco Flores on 16/05/22.
//

import Foundation
import Firebase

protocol ControllerView {
    func startLoading()
    func finishLoading()
    func Controller(success: Bool)
}
class ViewControllerPresenter {
    
    var view:ControllerView?
    
    init(){
    }
    func attachView(_ view: ControllerView){
        self.view = view
    }
    
    func controller(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let result = result, error == nil {
                self.view?.Controller(success: true)
            }else {
                self.view?.Controller(success: false)
            }
            
        }
        
    }
}
