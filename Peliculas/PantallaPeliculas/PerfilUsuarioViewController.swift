//
//  PerfilUsuarioViewController.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 05/05/22.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore

class PerfilUsuarioViewController: UIViewController {

    @IBOutlet weak var lblCorreoElectronico: UILabel!
    @IBOutlet weak var lblEdadUsuario: UILabel!
    @IBOutlet weak var lblNombreUsuario: UILabel!
    @IBOutlet weak var imgPerfil: UIImageView!
    
    private var email: String
    init() {
        self.email = ""
        super.init(nibName: nil, bundle: nil)
        
       
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
        getDataUser()
    }
    
    let db = Firestore.firestore()
    
    func getDataUser(){
        view.endEditing(true)
        db.collection("usuario").document(email).getDocument{
            (documentSnapshot, error) in
            
            if let document = documentSnapshot, error == nil {
                if let usuario = document.get("Nombres") as? String {
                    self.lblNombreUsuario.text = usuario
                }else {self.lblNombreUsuario.text = "" }
                
                if let nombre = document.get("Edad") as? String {
                    self.lblEdadUsuario.text = nombre
                }else {
                    self.lblEdadUsuario.text = ""
                }
            }else {
                self.lblNombreUsuario.text = ""

                self.lblEdadUsuario.text = ""
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
