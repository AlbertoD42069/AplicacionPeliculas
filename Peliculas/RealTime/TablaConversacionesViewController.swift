//
//  TablaConversacionesViewController.swift
//  Peliculas
//
//  Created by Hector Guadalupe Climaco Flores on 23/06/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseRemoteConfig
import SwiftUI
import JGProgressHUD
import MessageKit


class TablaConversacionesViewController: UIViewController {
    
    let sppiner  = JGProgressHUD()
    
    @IBOutlet weak var btnNuevaConversacion: UIButton!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var tableConversaciones: UITableView!
    var titulo = "conversaciones"
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitulo.text = "Conversaciones"
        lblTitulo.textAlignment = .center
        lblTitulo.font = UIFont.preferredFont(forTextStyle: .title1)
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        delegate()
        presentarCelda()

    }
    override func viewWillAppear(_ animated: Bool) {
        
        sppiner.dismiss()
    }

}

extension TablaConversacionesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableConversaciones.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CeldaConversacionTableViewCell
        celda.lblConversacion.text = "conversacion"
        
        return celda
    }
    
    func delegate() {
        tableConversaciones.dataSource = self
        tableConversaciones.delegate = self
    }
    func presentarCelda() {
        let celdaChat = UINib(nibName: "CeldaConversacionTableViewCell", bundle: nil)
        tableConversaciones.register(celdaChat, forCellReuseIdentifier: "celda")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        chatVC.title = "Persona"
        navigationController?.pushViewController(chatVC, animated: true)
        }
    
}
