//
//  DetallesPeliculaViewController.swift
//  Peliculas
//
//  Created by HJesus Alberto Diaz Dominguez on 05/05/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DetallesPeliculaViewController: UIViewController {

    @IBOutlet weak var imgPeliculas: UIImageView!
    
    @IBOutlet weak var btnFavoritos: UIButton!
    
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblPromedio: UILabel!
    @IBOutlet weak var lblLenguaje: UILabel!
    @IBOutlet weak var lblFechaEstreno: UILabel!
    @IBOutlet weak var lblNombrePelicula: UILabel!
    
    let dataBase = Firestore.firestore()
    let usuario = Auth.auth().currentUser
    
    var pelicula:Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if
            let nombrePelicula = pelicula?.original_title,
            let descripcionPelicula = pelicula?.overview,
            let idiomaPelicula = pelicula?.original_language,
            let imagenPoster = pelicula?.poster_path,
            let fechaEstreno = pelicula?.release_date
        {
            lblNombrePelicula.text = nombrePelicula
            lblDescripcion.text = "descripcion \n\(descripcionPelicula)"
            lblLenguaje.text = "idioma: \(idiomaPelicula)"
            lblFechaEstreno.text = "estreno: \(fechaEstreno)"
        
            let linkDefault = "https://image.tmdb.org/t/p/w500/"
            let completeLink = linkDefault + imagenPoster
            imgPeliculas.downloaded(from: completeLink)
            
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func btnActionFavoritos(_ sender: Any) {
    
            guard let id = pelicula?.id else {return}
        guard let nombre = pelicula?.original_title else {return}

            dataBase.collection("PeliculasFavoritas").document(usuario!.uid).setData([nombre: id], merge: true){
                err in
                if let err = err {
                    print("Archivo: \(err) no añadido a pelicula")
                } else {
                    print("Archivo añadido a peliculas")
                }
            }
        }
    
}




