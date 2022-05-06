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
    
    var pelicula:MovieViewData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if
            let nombrePelicula = pelicula?.title,
            let descripcionPelicula = pelicula?.resume,
            let idiomaPelicula = pelicula?.rating,
            let imagenPoster = pelicula?.image,
            let fechaEstreno = pelicula?.date
        {
            lblNombrePelicula.text = nombrePelicula
            lblDescripcion.text = descripcionPelicula
            lblLenguaje.text = String(idiomaPelicula)
            lblFechaEstreno.text = fechaEstreno
        
            let linkDefault = "https://image.tmdb.org/t/p/w500/"
            let completeLink = linkDefault + imagenPoster
            imgPeliculas.downloaded(from: completeLink)
            
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func btnActionFavoritos(_ sender: Any) {
    
            guard let id = pelicula?.id else {return}
        guard let nombre = pelicula?.title else {return}

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




