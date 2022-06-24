//
//  ViewController.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 04/05/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseInstallations
import FirebaseRemoteConfig
import JGProgressHUD

class ViewController: UIViewController, ControllerView{
    var fecha = Fecha()
    private let remoteConfig = RemoteConfig.remoteConfig()
        
    let register = RegistrarseViewController()
    
    let sppiner = JGProgressHUD()
    
    func updateDataFromRemoteConfig(){
        let title = RCValues.sharedInstance.string(forKey: .TitleButtonRegister)
        btnRegister.setTitle(title, for: .normal)

    }
    
    
    func startLoading() {
        
    }
    
    func finishLoading() {
        
    }
    
    func Controller(success: Bool) {
        if success {
        
           let vc = PantallaPeliculasViewController()
        self.navigationController?.pushViewController(vc, animated: false)
            vc.title = "conversaciones"
        }
    }
    

    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    var presenter:ViewControllerPresenter?
    private let db = Firestore.firestore()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        obtenerValores()
        presenter = ViewControllerPresenter()
        presenter?.attachView(self)
        fecha.fecha()
        
        //comprobacion de que exista el UserDefault
        let userDefailt = UserDefaults.standard
        if let email = userDefailt.value(forKey: "email") as? String,
           let password = userDefailt.value(forKey: "pass") as? String {
            self.presenter?.controller(email: email, password: password)
            print("con sesion iniciada")
            sppiner.textLabel.text = "cargado"
            sppiner.show(in: self.view)
            
        }else {
            print("sin sesion iniciada")
        }
   
    }
    override func viewWillAppear(_ animated: Bool) {
        
    
        super.viewWillAppear(animated)
        RCValues.sharedInstance.fetchCloudValues()
        RCValues.sharedInstance.loadingDoneCallback = updateDataFromRemoteConfig
        sppiner.dismiss()

        
        
    }
    @IBAction func btnActionRegister(_ sender: Any) {
        navigationController?.pushViewController(RegistrarseViewController(), animated: true)
    }
    
    @IBAction func btnActionLogIn(_ sender: Any) {
        navigationController?.pushViewController(LogInViewController(), animated: true)
    }    
}
extension ViewController {
    
    func obtenerValores(){
        let parametro: [String: NSObject] = ["isActiveNewScreen": false as NSObject]
        
        remoteConfig.setDefaults(parametro)
        
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        remoteConfig.configSettings = setting
        let parametroRemoteConfig = self.remoteConfig.configValue(forKey: "isActiveNewScreen").boolValue
        
        self.remoteConfig.fetch(withExpirationDuration: 0, completionHandler: { status, error in
            if status == .success, error == nil {
                self.remoteConfig.activate(completion: {status, error  in
                    guard error == nil else {
                        print("error \(error)")
                        return
                    }
                    let parametro = self.remoteConfig.configValue(forKey: "isActiveNewScreen").boolValue
                    
                    print("el estado es: \(parametro)")
                    
                    DispatchQueue.main.async {
                    
                    self.nombreBoton()
                    }
                })
            }
        })
    }
    
    func nombreBoton(){
       
    }
    
}
