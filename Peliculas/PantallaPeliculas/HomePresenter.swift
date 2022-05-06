//
//  HomePresenter.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 05/05/22.
//

import Foundation
import UIKit

struct MovieViewData{
    let id:Int
    let title: String
    let image: String
    let rating : Double
    let resume : String
    let date : String
    
}
enum type  {
    case popular
    case topRated
    case onTv
    case airingTV
}
protocol HomeView {
    func startLoading()
    func finishLoading()
    func setMovies(_ movies: [MovieViewData])
    func setEmptyMovies()
   
}

class HomePresenter {
    let userService:ServiceManager
    var userView : HomeView?
    
    init(userService:ServiceManager){
        self.userService = userService
    }
    
    func attachView(_ view:HomeView){
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
    func getMovies(typecatalog: type){
        var url = Urls.linkPopular
        switch typecatalog {
        case .popular:
            url = Urls.linkPopular
            break
        case .airingTV:
            url = Urls.linkAiringToday
            break
        case .onTv:
            url = Urls.linkOnTv
            break
        case .topRated:
            url = Urls.linkTopRated
            break
        }
        
        //MOVIE
        self.userView?.startLoading()
        userService.execute(url: url, complited:{ [weak self] movies in
            self?.userView?.finishLoading()
            if(movies.count == 0){
                self?.userView?.setEmptyMovies()
            }else{
                let mappedUsers = movies.map{
                    return MovieViewData(id:$0.id, title: $0.original_title ?? $0.name ?? "Desconocido", image: $0.poster_path, rating: $0.vote_average, resume: $0.overview, date: $0.release_date ?? $0.first_air_date ?? "No date")
                }
                self?.userView?.setMovies(mappedUsers)
            }
        })
    }
    
    
    func addfavorite(movie:MovieViewData){
        let favoriteManager = FavoritesManager()
        favoriteManager.setFavorites(movie: movie)
    }
    
    func goToMoviewDetail(nav:UINavigationController?, movie:MovieViewData)
    {
        let detalles = DetallesPeliculaViewController()
        detalles.pelicula = movie
        nav?.pushViewController(detalles, animated: true)
    }
    
}
