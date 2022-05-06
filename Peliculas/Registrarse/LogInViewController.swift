//
//  LogInViewController.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 04/05/22.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var lblEstadoSesion: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnActionLogIn(_ sender: Any) {
        if let email = txtUsername.text, let Contraseña = txtPassword.text {
            Auth.auth().signIn(withEmail: email, password: Contraseña) { result, error in
                if let result = result, error == nil {
                    self.navigationController?.pushViewController(PantallaPeliculasViewController(email: result.user.email!, provider:  .basic), animated: true)
                    
                }else{
                    
                   self.lblEstadoSesion.textColor = UIColor.red
                   self.lblEstadoSesion.text = "Invalid username and/or password: You did not provide a valid login"
                    /*let alertController = UIAlertController(title: "Error", message: "Se a producido un error registrando el usario", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alertController, animated: true, completion: nil)*/
                    
                    
                }
            }
        }
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
