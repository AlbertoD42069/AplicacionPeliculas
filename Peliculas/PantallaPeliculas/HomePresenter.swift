//
//  HomePresenter.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 05/05/22.
//

import Foundation

struct MovieViewData{
    let id:Int
    let title: String
    let image: String
    let rating : Double
    let resume : String
    let date : String
    
}
enum typeMovies  {
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
    
    func getMovies(typecatalog: typeMovies){
        var url = Urls.linkPopular
        switch typecatalog {
        case .popular:
            url = Urls.linkPopular
            break
        case .airingTV:
            url = Urls.linkPopular
            break
        case .onTv:
            url = Urls.linkPopular
            break
        case .topRated:
            url = Urls.topRated
            break
        }
        
        self.userView?.startLoading()
        userService.execute(url: Urls.linkPopular, complited:{ [weak self] movies in
            self?.userView?.finishLoading()
            if(movies.count == 0){
                self?.userView?.setEmptyMovies()
            }else{
                let mappedUsers = movies.map{
                    return MovieViewData(id:$0.id,title: $0.original_title, image: $0.poster_path, rating: $0.vote_average, resume: $0.overview, date: $0.release_date)
                }
                self?.userView?.setMovies(mappedUsers)
            }
            
        })
    }
    func addfavorite(movie:MovieViewData){
        let favoriteManager = FavoritesManager()
        favoriteManager.setFavorites(movie: movie)
    }
    
}
