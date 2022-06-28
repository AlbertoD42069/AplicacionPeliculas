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
import FirebaseDatabase

struct Conversacion {
    var id: String
    //let name: String
    let otroUsuario: String
    let latestMenssaage: LatestMenssage
}
struct LatestMenssage {
    let date: String
    let text: String
    let isRead: Bool
}



class TablaConversacionesViewController: UIViewController {
    var ref = Database.database().reference()
    var conversacion = [Conversacion]()

    
    let sppiner  = JGProgressHUD()
    @IBOutlet weak var tableConversaciones: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "conversaciones"
        navigationItem.backButtonTitle = "Back"
        delegate()
        presentarCelda()
        startListeningForConversation()

    }
    override func viewWillAppear(_ animated: Bool) {
        
        sppiner.dismiss()
    }

}


extension TablaConversacionesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        conversacion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversacion[indexPath.row]
        //var status = false
        let celda = tableConversaciones.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CeldaConversacionTableViewCell
        //celda.lblConversacion.text = contacto[indexPath.row]
        celda.configure(with: model)
        return celda
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = conversacion[indexPath.row]
        let chatVC = ChatViewController(con: model.otroUsuario, tambien: " ")
        chatVC.title = model.id
        chatVC.isNewConvesation = true
        navigationController?.pushViewController(chatVC, animated: true)
        
    }
    func delegate() {
        tableConversaciones.dataSource = self
        tableConversaciones.delegate = self
    }
    func presentarCelda() {
        let celdaChat = UINib(nibName: "CeldaConversacionTableViewCell", bundle: nil)
        tableConversaciones.register(celdaChat, forCellReuseIdentifier: "celda")
    }
    
}
extension TablaConversacionesViewController {
    
    func startListeningForConversation() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        print("starting conversation fetch...")
        let safeEmail = safeEmail(con: email)
        getAllConversation(for: safeEmail, completion: {[weak self] result in
            switch result {
            case .success(let conversation):
                print("successfully got convesation models")
                guard !conversation.isEmpty else {
                    return
                }
                self?.conversacion = conversation
                DispatchQueue.main.async {
                    self?.tableConversaciones.reloadData()
                }
            case .failure(let error):
                print("error")
            }
        })
        
    }
}

extension TablaConversacionesViewController {
    func getAllConversation(for email: String, completion: @escaping (Result<[Conversacion],Error>) -> Void){
        ref.child("\(email)/conversacion").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String:Any]] else {
                completion(.failure(DataBaseError.failedToFetch))
                return
            }
            
            let conversations: [Conversacion] = value.compactMap({dictionary in
                guard let conversationId = dictionary["id"] as? String,
                //let name = dictionary["name"] as? String,
                let otherUser = dictionary["other_user_email"] as? String,
                let latestMessage = dictionary["lastest_message"] as? [String: Any],
                let date = latestMessage["date"] as? String,
                let message = latestMessage["menssage"] as? String,
                let isRead = latestMessage["is_read"] as? Bool else {
                return nil
                }
                let latestMessageObject = LatestMenssage(date: date, text: message, isRead: isRead)
                return Conversacion(id: conversationId, otroUsuario: otherUser, latestMenssaage: latestMessageObject)
            })
            completion(.success(conversations))
        })
    }
}
extension TablaConversacionesViewController {
    func safeEmail(con email:String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    enum DataBaseError: Error {
        case failedToFetch
        public var localizedDescription : String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
    }
}

