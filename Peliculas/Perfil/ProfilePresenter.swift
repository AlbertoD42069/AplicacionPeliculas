//
//  ProfilePresenter.swift
//  Peliculas
//
//  Created by Adrian Dominguez Gómez on 06/05/22.
//

import Foundation

struct ProfileModel {
    let name : String
    let email : String
    let age: String
    let favorites : [String] = []
}
protocol ProfileView {
    func startLoading()
    func finishLoading()
    func refresh(_ movies: ProfileModel)
}



class ProfilePresenter {
    var view:ProfileView?
    
    init(){
        
    }
    func attachView(_ view:ProfileView){
        self.view = view
    }
    
    
    
}
