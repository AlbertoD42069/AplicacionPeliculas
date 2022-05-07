//
//  PerfilUsuarioViewController.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 05/05/22.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore

class PerfilUsuarioViewController: UIViewController, ProfileView{
    @IBOutlet weak var tablaFavoritos: UITableView!
    func updateFavorites(_ data: [FavoriteItem]) {
        self.favorites = data
        self.tablaFavoritos.reloadData()
    }
    

    var favorites: [FavoriteItem] = []
    var presenter: ProfilePresenter?
    @IBOutlet weak var lblCorreoElectronico: UILabel!
    @IBOutlet weak var lblEdadUsuario: UILabel!
    @IBOutlet weak var lblNombreUsuario: UILabel!
    @IBOutlet weak var imgPerfil: UIImageView!
    
    private var email: String
    init() {
        self.email = ""
        super.init(nibName: nil, bundle: nil)
        self.presenter = ProfilePresenter()
        self.presenter?.attachView(self)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefault = UserDefaults.standard
        
        if let email = userDefault.value(forKey: "email") as? String {
            self.email = email
        }else
        {
            self.email = ""
        }
        presenter?.getData()
        presenter?.getFavorites()
        let celdaFavoritos = UINib(nibName: "FavoritosTableViewCell", bundle: nil)
        tablaFavoritos.register(celdaFavoritos, forCellReuseIdentifier: "FavoritosTableViewCell")
        tablaFavoritos.dataSource = self
    }
       
    func startLoading() {
    }
    
    func finishLoading() {
 
    }
    
    func refresh(_ data: ProfileViewData) {
        self.lblNombreUsuario.text = data.name
        self.lblEdadUsuario.text = data.age
        lblCorreoElectronico.text = data.email
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PerfilUsuarioViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celdaFavoritos = tablaFavoritos.dequeueReusableCell(withIdentifier: "FavoritosTableViewCell", for: indexPath) as! FavoritosTableViewCell
        
        let item = self.favorites[indexPath.row]
        
        celdaFavoritos.lblTitle.text = item.title
        celdaFavoritos.delegate = self
        return celdaFavoritos
    }
    
    
    
}


extension PerfilUsuarioViewController: FavoriteCellDelegate {
    func eliminarFavorito(cell: UITableViewCell) {
        let index = self.tablaFavoritos.indexPath(for: cell)
        if let row = index?.row{
            let item = self.favorites[row]
            self.presenter?.deleteFavorites(name: item.title)
        }
    }
    
    
}
