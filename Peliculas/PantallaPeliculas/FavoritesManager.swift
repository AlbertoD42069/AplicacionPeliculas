//
//  FavoritesManager.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 05/05/22.
//

import Foundation
import Firebase
struct FavoriteItem {
    var id:Int
    var title: String
}
let collection = "PeliculasFavoritas"

class FavoritesManager {
    let dataBase = Firestore.firestore()
    var favorites : [FavoriteItem] = []
    func setFavorites(movie:MovieViewData){
        let datosUsuario = Auth.auth().currentUser
        guard let idUusario = datosUsuario?.uid else { return }
        
        dataBase.collection(collection).document(idUusario).setData([movie.title : "\(movie.id)"] , merge: true){ err in
            if let err = err {
                print("Archivo: \(err) no añadido a pelicula")
            }else {
                print("Archivo añadido a peliculas")
            }
        }
    }
    
  
    
    func getFavorites( completion:@escaping ([FavoriteItem])->Void){
        let db = Firestore.firestore()
        let datosUsuario = Auth.auth().currentUser
        guard let idUusario = datosUsuario?.uid else { return }
       
        //datos del documento
        let datosMovieFav = db.collection(collection).document(idUusario)
        
        //traer los datos del diccionario del usuario
        datosMovieFav.getDocument {  (document, err) in
         
            if let document = document, document.exists {
                
                if let dataDictionary = document.data(){
                   dump(dataDictionary)
                    for item in dataDictionary {
                        if let id = item.value as? Int {
                           let newElement =  FavoriteItem(id: id, title: item.key)
                            self.favorites.append(newElement)
                        }
                    }
                    completion(self.favorites ?? [])
                }
            }else {
                print("Document don't exist")
            }
        }
    }
    
    
    func deleteFavorite(name:String, completion: @escaping ()->()){
        let db = Firestore.firestore()
        let datosUsuario = Auth.auth().currentUser
        guard let idUusario = datosUsuario?.uid else { return }
       
        //datos del documento
        let datosMovieFav = db.collection(collection).document(idUusario)
        
        //traer los datos del diccionario del usuario
        datosMovieFav.getDocument {  (document, err) in
         
            if let document = document, document.exists {
                
                if let dataDictionary = document.data(){
                   
                   var newDict =  dataDictionary
                    newDict.removeValue(forKey: name)
                    
                    db.collection(collection).document(idUusario).setData(newDict)
                    completion()
                }
            }else {
                print("Document don't exist")
            }
        }
    }
    
}
