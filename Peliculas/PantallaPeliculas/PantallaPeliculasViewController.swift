//
//  PantallaPeliculasViewController.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez Flores on 04/05/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PantallaPeliculasViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var movies:[MovieViewData]=[]
    var presenter:HomePresenter?
    private let db = Firestore.firestore()

    
    @IBOutlet weak var btnLista: UIButton!
    @IBOutlet weak var Coleccion: UICollectionView!
    
    @IBOutlet weak var lblTitulo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let celdaColeccion = UINib(nibName: "CeldaPeliculaCollectionViewCell", bundle: nil)
        Coleccion.register(celdaColeccion, forCellWithReuseIdentifier: "CeldaColeccion")
        Coleccion.delegate = self
        Coleccion.dataSource = self
        // Do any additional setup after loading the view.
        
        let serviceManager = ServiceManager()
        presenter = HomePresenter(userService: serviceManager)
        presenter?.attachView(self)
        presenter?.getMovies(typecatalog: .popular)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
      
    }
    @IBAction func TopRatedTapped(_ sender: Any) {
        self.lblTitulo.text = "Top Rated"
        presenter?.getMovies(typecatalog: .topRated)
    }
    
    @IBAction func btnPopular(_ sender: Any) {
        self.lblTitulo.text = "Popular"
        presenter?.getMovies(typecatalog: .popular)
    }
    
    @IBAction func btnOnTV(_ sender: Any) {
        self.lblTitulo.text = "On Tv"
        presenter?.getMovies(typecatalog: .onTv)
    }
    
    @IBAction func btnAiringToday(_ sender: Any) {
        self.lblTitulo.text = "Airing Today"
        presenter?.getMovies(typecatalog: .airingTV)
    }
    
    @IBAction func btnActionLista(_ sender: Any) {
        
        
        let perfil = UIAlertController(title: "perfil", message: " " , preferredStyle: .actionSheet)
        
        perfil.addAction(UIAlertAction(title: "Ver perfil", style: .default, handler: { (action) in
            let pantallaPerfil = PerfilUsuarioViewController()
            self.navigationController?.pushViewController(pantallaPerfil, animated: true)
        }))
        let action = UIAlertAction(title: "Cerrar Sesión", style: .default) { action in
            self.logout()
        }
        perfil.addAction(action)
        
        self.present(perfil, animated: true)
    }
    func logout() {
        do {
            
            let result = try? Auth.auth().signOut()
            if (result != nil) {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if  let initialViewController = storyboard.instantiateInitialViewController() {
                        initialViewController.modalPresentationStyle = .fullScreen
                        self.present(initialViewController, animated: true) {
                            
                                    self.navigationController?.viewControllers.removeAll()
                                
                            }
                            
                    
                        }
                    

                }
                  
            }
            
        }catch{
            print("error")
        }
    }
}

extension PantallaPeliculasViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    //CeldaColeccion
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celdaColeccion = Coleccion.dequeueReusableCell(withReuseIdentifier: "CeldaColeccion", for: indexPath) as! CeldaPeliculaCollectionViewCell
        
        celdaColeccion.lblNombrePelicula.text = movies[indexPath.row].title.capitalized
        celdaColeccion.lblFechaEstreno.text = movies[indexPath.row].date.capitalized
        celdaColeccion.lblDescripcion.text = movies[indexPath.row].resume
        
        
        celdaColeccion.imgPelicula.contentMode = .scaleAspectFill
        
        celdaColeccion.imgPelicula?.contentMode = .scaleAspectFill
        let linkDefault = "https://image.tmdb.org/t/p/w500/"
        let completeLink = linkDefault + movies[indexPath.row].image
        celdaColeccion.imgPelicula?.downloaded(from: completeLink)
        celdaColeccion.imgPelicula?.clipsToBounds = true
        celdaColeccion.imgPelicula.layer.cornerRadius = celdaColeccion.imgPelicula.frame.height/2
        
        return celdaColeccion
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        presenter?.goToMoviewDetail(nav: self.navigationController, movie: movie)
       
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension PantallaPeliculasViewController: HomeView {
    func addfavorite(movieId: String) {
    }
    
    func startLoading() {
        
    }
    
    func finishLoading() {
        
    }
    
    func setMovies(_ movies: [MovieViewData]) {
        self.movies = movies
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
