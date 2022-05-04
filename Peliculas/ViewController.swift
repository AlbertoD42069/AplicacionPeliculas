//
//  ViewController.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 04/05/22.
//

import UIKit
import FirebaseAuth
import FirebaseAnalytics

class ViewController: UIViewController {

    @IBOutlet weak var btnIniciarSesion: UIButton!
    @IBOutlet weak var lblEstadoLogin: UILabel!
    @IBOutlet weak var txtPasword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnActionIniciarSesion(_ sender: Any) {
        if let email = txtEmail.text, let Contraseña = txtPasword.text {
            Auth.auth().signIn(withEmail: email, password: Contraseña) { result, error in
                if let result = result, error == nil {
                    self.navigationController?.pushViewController(PantallaPeliculasViewController(), animated: true)
                    
                }else{
                    
                    self.lblEstadoLogin.textColor = UIColor.red
                    self.lblEstadoLogin.text = "Invalid username and/or password: You did not provide a valid login"
                    /*let alertController = UIAlertController(title: "Error", message: "Se a producido un error registrando el usario", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alertController, animated: true, completion: nil)*/
                    
                    
                }
            }
        }
    }
    
}

