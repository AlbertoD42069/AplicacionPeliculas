//
//  LoginPresenter.swift
//  Peliculas
//
//  Created by Adrian Dominguez Gómez on 06/05/22.
//

import Foundation
import Firebase
protocol LoginView {
    func startLoading()
    func finishLoading()
    func Login(success: Bool)
}



class LoginPresenter {
    var view: LoginView?
    
    init(){
    }
    
    func attachView(_ view:LoginView){
        self.view = view
    }
    
    func login(email:String, pass:String){
    
        let userDefailt = UserDefaults.standard
        userDefailt.set(email, forKey: "email")
        Auth.auth().signIn(withEmail: email, password: pass) { result, error in
            if let result = result, error == nil {
            
                self.view?.Login(success: true)
            }else{
                self.view?.Login(success: false)
            }
        }
    }
}
