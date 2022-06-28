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
    var contacto: [String] = ["JUAN", "PEDRO", "LUCAS", "MATEO", "JOSE"]
    @IBOutlet weak var tableConversaciones: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "conversaciones"
        navigationItem.backButtonTitle = "Back"
        delegate()
        presentarCelda()

    }
    override func viewWillAppear(_ animated: Bool) {
        
        sppiner.dismiss()
    }

}


extension TablaConversacionesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableConversaciones.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CeldaConversacionTableViewCell
        celda.lblConversacion.text = contacto[indexPath.row]
        
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
        let chatVC = ChatViewController(con: " ", ID: " ")
        chatVC.title = contacto[indexPath.row]
        chatVC.isNewConvesation = true
        navigationController?.pushViewController(chatVC, animated: true)
        }
    
}
