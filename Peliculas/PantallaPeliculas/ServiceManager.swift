//
//  ExeuteJson.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 05/05/22.
//

import Foundation

class Urls {
    static let linkPopular = "https://api.themoviedb.org/3/movie/popular?api_key=c89f997b9f805d783c81fc1e854ed7d1"
    static let linkTopRated = "https://api.themoviedb.org/3/movie/top_rated?api_key=c89f997b9f805d783c81fc1e854ed7d1"
    static let linkOnTv = "https://api.themoviedb.org/3/tv/on_the_air?api_key=c89f997b9f805d783c81fc1e854ed7d1"
    static let linkAiringToday = "https://api.themoviedb.org/3/tv/airing_today?api_key=c89f997b9f805d783c81fc1e854ed7d1"
}
class ServiceManager {

    func execute(url:String, complited: @escaping (_ movies:[Movie])-> () ) {
        let urlSesion = URLSession.shared
        let url = URL(string: url)
        urlSesion.dataTask(with: url!) { data, response, error in
            if error == nil {
                do {
                    let response = try JSONDecoder().decode(Movies.self, from: data!)
                    DispatchQueue.main.async {
                        complited(response.results)
                    }
                }catch{
                    print("json error")
                }
            }
        }.resume()
    }
}
