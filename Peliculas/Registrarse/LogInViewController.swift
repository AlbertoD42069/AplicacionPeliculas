//
//  LogInViewController.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 04/05/22.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController, LoginView {
    
    func startLoading() {
        
    }
    
    func finishLoading() {
        
    }
    
    func Login(success: Bool) {
        if success {
            self.navigationController?.pushViewController(PantallaPeliculasViewController(), animated: true)
        }else {
            self.lblEstadoSesion.textColor = UIColor.red
            self.lblEstadoSesion.text = "Invalid username and/or password: You did not provide a valid login"
        }
        
    }
    
    var presenter:LoginPresenter?
    
    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var lblEstadoSesion: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter = LoginPresenter()
        presenter?.attachView(self)
    }

    @IBAction func btnActionLogIn(_ sender: Any) {
        if let email = txtUsername.text, let Contraseña = txtPassword.text {
            self.presenter?.login(email: email, pass: Contraseña)
        }
    }
    
    @IBAction func btnActionRegistro(_ sender: Any) {
        navigationController?.pushViewController(RegistrarseViewController(), animated: true)
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
