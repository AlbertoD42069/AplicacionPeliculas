//
//  PantallaPeliculasViewController.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez Flores on 04/05/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

enum ProviderTypes: String {
    case basic
}

class PantallaPeliculasViewController: UIViewController {
    
    var moviePopulares:[MovieViewData]=[]
    var presenter:HomePresenter?

    @IBOutlet weak var topRatedButton: UIButton!
    @IBOutlet weak var Coleccion: UICollectionView!

    
    private let email: String
    private let provider: ProviderTypes
    private let db = Firestore.firestore()
    
    
    init(email: String, provider: ProviderTypes){
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    
        title = "TV show"
        view.backgroundColor = .systemGray
        
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
        
        let celdaColeccion = UINib(nibName: "CeldaPeliculaCollectionViewCell", bundle: nil)
        Coleccion.register(celdaColeccion, forCellWithReuseIdentifier: "CeldaColeccion")
        Coleccion.delegate = self
        Coleccion.dataSource = self
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let serviceManager = ServiceManager()
        presenter = HomePresenter(userService: serviceManager)
        presenter?.attachView(self)
        presenter?.getMovies(typecatalog: .popular)
      
    }
    @IBAction func TopRatedTapped(_ sender: Any) {
        self.title = "Top Rated"
        presenter?.getMovies(typecatalog: .popular)
    }
    
    
}

extension PantallaPeliculasViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviePopulares.count
    }
    //CeldaColeccion
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celdaColeccion = Coleccion.dequeueReusableCell(withReuseIdentifier: "CeldaColeccion", for: indexPath) as! CeldaPeliculaCollectionViewCell
        
        celdaColeccion.lblNombrePelicula.text = moviePopulares[indexPath.row].title
        celdaColeccion.lblFechaEstreno.text = moviePopulares[indexPath.row].date.capitalized
        celdaColeccion.lblDescripcion.text = moviePopulares[indexPath.row].resume
        
        
        celdaColeccion.imgPelicula.contentMode = .scaleAspectFill
        
        celdaColeccion.imgPelicula?.contentMode = .scaleAspectFill
        let linkDefault = "https://image.tmdb.org/t/p/w500/"
        let completeLink = linkDefault + moviePopulares[indexPath.row].image
        celdaColeccion.imgPelicula?.downloaded(from: completeLink)
        celdaColeccion.imgPelicula?.clipsToBounds = true
        
        return celdaColeccion
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detalles = DetallesPeliculaViewController()
        navigationController?.pushViewController(detalles, animated: true)
    }
 
    
}

extension PantallaPeliculasViewController: HomeView {
    func startLoading() {
        
    }
    
    func finishLoading() {
        
    }
    
    func setMovies(_ movies: [MovieViewData]) {
        self.moviePopulares = movies
        self.Coleccion.reloadData()
    }
    
    func setEmptyMovies() {
        
    }
    
   
    
     
    
}
extension PantallaPeliculasViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let with = self.view.frame.width / 2 - 5
        let height = self.view.frame.height / 3 - 5
        return CGSize(width: with, height: height)
    }
}
