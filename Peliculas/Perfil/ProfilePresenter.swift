//
//  ProfilePresenter.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 05/05/22.
//

import Foundation
import Firebase
struct ProfileViewData {
    let name : String
    let email : String
    let age: String
}
protocol ProfileView {
    func startLoading()
    func finishLoading()
    func refresh(_ data: ProfileViewData)
    func updateFavorites(_ data: [FavoriteItem])
}



class ProfilePresenter {
    var view:ProfileView?
    
    init(){
        
    }
    func attachView(_ view:ProfileView){
        self.view = view
    }
    
    
    func getData(){
        let db = Firestore.firestore()
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
                
         db.collection("usuario").document(email).getDocument{
            (documentSnapshot, error) in
            
            if let document = documentSnapshot, error == nil {
                
                if let usuario = document.get("Nombres") as? String,
                   let edad = document.get("Edad") as? String
                {
                   let data = ProfileViewData(name: usuario, email: email , age: edad)
                    self.view?.refresh(data)
                }
             }
            }
    
    }
    
    func getFavorites(){
        let favorites = FavoritesManager()
        favorites.getFavorites { favoritesItems in
            self.view?.updateFavorites(favoritesItems)
        }
    }
    
    
    func deleteFavorites(name:String){
        
        let favorites = FavoritesManager()
        favorites.deleteFavorite(name: name) {
            self.getFavorites()
        }
        
    }
}
