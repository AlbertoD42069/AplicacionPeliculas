//
//  LoginPresenter.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 05/05/22.
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
        Auth.auth().signIn(withEmail: email, password: pass) { result, error in
            if let result = result, error == nil {
                self.view?.Login(success: true)
                
                //guardar datos en UserDefaults
                let userDefailt = UserDefaults.standard
                userDefailt.set(email, forKey: "email")
                userDefailt.set(pass, forKey: "pass")
                userDefailt.synchronize()
                
            }else{
                self.view?.Login(success: false)
            }
        }
    }
}
