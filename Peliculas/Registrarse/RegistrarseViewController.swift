//
//  RegistrarseViewController.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 04/05/22.
//

import UIKit
import FirebaseAuth
//import FirebaseAnalytics
import FirebaseFirestore

class RegistrarseViewController: UIViewController {

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEdad: UITextField!
    @IBOutlet weak var txtNombres: UITextField!
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnActionRegister(_ sender: Any) {
        let userData = UserData.shared
        
        if let email = txtUsername.text, let contraseña = txtPassword.text {
            Auth.auth().createUser(withEmail: email, password: contraseña) { result, error in
                if let result = result, error == nil {
                    userData.userId = result.user.uid
                    
                    
                    self.navigationController?.pushViewController(PantallaPeliculasViewController(), animated: true)
                    let alertaController = UIAlertController(title: "Guardado", message: "Registro existoso" , preferredStyle: .alert)
                        alertaController.addAction(UIAlertAction(title: "aceptar", style: .default))
                        self.present(alertaController, animated: true, completion: nil)
                }
            }
            self.db.collection("usuario").document(email).setData([
                "Nombres":self.txtNombres.text ?? "",
                "Edad":self.txtEdad.text ?? ""], merge: true)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Se a producido un error registrando el usario", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alertController, animated: true, completion: nil)
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
