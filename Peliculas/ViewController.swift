//
//  ViewController.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 04/05/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
//import FirebaseAnalytics
enum ProviderInicio: String {
    case basic
}
class ViewController: UIViewController {

    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad(){
        super.viewDidLoad()
   
    }
    @IBAction func btnActionRegister(_ sender: Any) {
        navigationController?.pushViewController(RegistrarseViewController(), animated: true)
    }
    
    @IBAction func btnActionLogIn(_ sender: Any) {
        navigationController?.pushViewController(LogInViewController(), animated: true)
    }    
}

