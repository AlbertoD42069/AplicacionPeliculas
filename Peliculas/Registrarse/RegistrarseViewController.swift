//
//  RegistrarseViewController.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 04/05/22.
//

import UIKit
import FirebaseAuth
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseRemoteConfig
import FirebaseCore
import FirebaseDatabase

class RegistrarseViewController: UIViewController, RegisterView {
    
    
    
    @IBOutlet weak var lblTitulo: UILabel!
    
    func updateDataFromRemoteConfigEncabezado(){
        
        let encabezado = RCValues.sharedInstance.string(forKey: .TitleRegisterScreen)
        lblTitulo?.text = encabezado
    }
    
    func startLoading() {
        
    }
    
    func finishLoading() {
        
    }
    
    func Register(success: Bool) {
        if success {
            self.navigationController?.pushViewController(PantallaPeliculasViewController(), animated: true)
            let alertaController = UIAlertController(title: "Guardado", message: "Registro existoso" , preferredStyle: .alert)
                alertaController.addAction(UIAlertAction(title: "aceptar", style: .default))
                self.present(alertaController, animated: true, completion: nil)
        }else {
            let alertController = UIAlertController(title: "Error", message: "Se a producido un error registrando el usario", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    var presenter: RegisterPresenter?
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEdad: UITextField!
    @IBOutlet weak var txtNombres: UITextField!
    
    private let db = Firestore.firestore()
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RegisterPresenter()
        presenter?.attachView(self)
        //viewcontroller.updateDataFromRemoteConfig()
        //updateDataFromRemoteConfigEncabezado()
        }
    override func viewWillAppear(_ animated: Bool) {
        
    
        super.viewWillAppear(animated)
        RCValues.sharedInstance.fetchCloudValues()
        RCValues.sharedInstance.loadingDoneCallback = updateDataFromRemoteConfigEncabezado
        
    }

    @IBAction func btnActionRegister(_ sender: Any) {
        
        if let email = txtUsername.text, let contraseña = txtPassword.text, let nombre = txtNombres.text, let edad = txtEdad.text {
            //presenter?.register(nombre: nombre, edad: edad, userName: email, pass: contraseña)
            
            presenter?.register(nombre: nombre, edad: edad, userName: email, pass: contraseña)
            
        } else {

        }
    }

}
