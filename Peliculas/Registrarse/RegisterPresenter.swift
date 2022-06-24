//
//  RegisterPresenter.swift
//  Peliculas
//
//  Created by Hector Guadalupe Climaco Flores on 16/05/22.
//

import Foundation
import Firebase
import FirebaseDatabase

protocol RegisterView {
    func startLoading()
    func finishLoading()
    func Register(success: Bool)
}

class RegisterPresenter {
    
    var view: RegisterView?
    init(){
        
    }
    func attachView(_ view:RegisterView){
        self.view = view
    }
    let db = Firestore.firestore()
    let ref = Database.database().reference()
    
    func register(nombre:String, edad:String, userName:String, pass:String){
        
        Auth.auth().createUser(withEmail: userName, password: pass) { result, error in
            self.view?.Register(success: true)
            if let result = result, error == nil {
                //var userNameModif = userName.replacingOccurrences(of: ".", with: "-")
                  //  userNameModif = userName.replacingOccurrences(of: "@", with: "-")
                self.ref.child("userName").setValue([
                    "Nombres": nombre ,
                    "Edad": edad,
                    "correo": userName
                ])
                
                /*self.db.collection("usuario").document(userName).setData([
                    "Nombres": nombre ?? "",
                    "Edad": edad ?? ""], merge: true)*/
                
                let userDefailt = UserDefaults.standard
                userDefailt.set(userName, forKey: "email")
                userDefailt.set(pass, forKey: "pass")
                userDefailt.synchronize()
                
                self.ref.child("userName").observeSingleEvent(of: .value) { snapshot in
                    
                    guard snapshot.value as? String != nil else {
                        return
                    }
                }
            }else{
                self.view?.Register(success: true)
            }
        }
        
    }
    
    func userExists(con userName: String, completion: @escaping ((Bool) -> Void) ){
       // var userNameModif = userName.replacingOccurrences(of: ".", with: "-")
         //   userNameModif = userName.replacingOccurrences(of: "@", with: "-")
        ref.child("userName").observeSingleEvent(of: .value) { snapshot in
            
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
        }
        completion(true)
        
    }
}
