//
//  ExeuteJson.swift
//  Peliculas
//
//  Created by Hector Guadalupe Climaco Flores on 05/05/22.
//

import Foundation

class Urls {
    static let linkPopular = "https://api.themoviedb.org/3/movie/popular?api_key=c89f997b9f805d783c81fc1e854ed7d1"
    static let topRated = "https://api.themoviedb.org/3/movie/top_rated?api_key=c89f997b9f805d783c81fc1e854ed7d1"
    static let OnTv = " "
    static let AiringToday = " "
}
class ServiceManager {

    func execute(url:String, complited: @escaping (_ movies:[Movie])-> () ) {
        let urlSesion = URLSession.shared
        let url = URL(string: url)
        urlSesion.dataTask(with: url!) { data, response, error in
            if error == nil {
                do {
                    let response = try JSONDecoder().decode(MoviesPResponse.self, from: data!)
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
