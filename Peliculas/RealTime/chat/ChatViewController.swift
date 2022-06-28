//
//  ChatViewController.swift
//  Peliculas
//
//  Created by Hector Guadalupe Climaco Flores on 23/06/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseRemoteConfig
import MessageKit
import InputBarAccessoryView
import FirebaseDatabase
import AVFoundation


class ChatViewController: MessagesViewController {
    
    public static var fecha: DateFormatter = {
        let fechaNueva = DateFormatter()
        fechaNueva.dateStyle = .medium
        fechaNueva.timeStyle = .long
        fechaNueva.locale = .current
        return fechaNueva
    }()
    
    
    var messages = [Message]()
    var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return nil }
        return Sender(senderId: email, displayName: " ")
    }
    var isNewConvesation = false
    var ref = Database.database().reference()
    let otroUsuarioEmail : String
    var conversationId : String?
    init(con email: String, ID: String?){
        self.otroUsuarioEmail = email
        self.conversationId = ID
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not bee implement")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hola persona")))
        //messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Como estas")))

        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
}
extension ChatViewController: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty ,
        let selfSender = self.selfSender,
        let mensajeID =  createMessageID() else {
            return
        }
        print("mensaje: \(text)")
        //isNewConvesation = true
        if isNewConvesation {
            let mensaje = Message(sender: selfSender, messageId: mensajeID, sentDate: Date(), kind: .text(text))
            crearNuevaConversacion(with: otroUsuarioEmail, firstMenssage: mensaje, completion: {[weak self] success in
                if success {
                    
                    print("mensaje enviado")
                }else {
                    print("mensaje no enviado")
                }
            })
        }else {
            
        }
        
    }
    func finalizarCreacionConversacion(with conversacionId: String, firstMessage: Message, completion: @escaping(Bool) -> Void) {
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.fecha.string(from: messageDate)
        var menssage = ""
        switch firstMessage.kind {
            case .text(let menssageText):
                menssage = menssageText
        case .attributedText(_), .photo(_), .video(_), .location(_), .emoji(_), .audio(_), .contact(_), .linkPreview(_), .custom(_):
            break
        }
            guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                completion(false)
                return
            }
            let currentUserEmail = safeEmail(con: myEmail)
            
        let menssageColeccion: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": menssage ,
            "date":  dateString ,
            "sender_email": currentUserEmail ,
            "is_read": false
        ]
        let value: [String: Any] = [
            "menssage": [
                menssageColeccion
            ]
        ]
        ref.child("\(conversacionId)").setValue(value, withCompletionBlock: {error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
        }
    func createMessageID() -> String? {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else
        {
            return nil
            
        }
        let correoModificado = safeEmail(con: currentUserEmail)
        
        let fechaString = Self.fecha.string(from: Date())
        let identificadorNuevo = "\(otroUsuarioEmail)_\(correoModificado)_\(fechaString)"
        print("ide de mensaje creado \(identificadorNuevo)")
        return identificadorNuevo
    }
}
extension ChatViewController {
    //mensaje en base de datos
    
    //crear nueva conversacion
    func crearNuevaConversacion(with otroUsuarioEmail : String, firstMenssage: Message, completion: @escaping(Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String  else {
            return
        }
        let safeEmail = safeEmail(con: currentEmail)
        let ref = ref.child("\(safeEmail)")
            ref.observeSingleEvent(of: .value, with: { snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not fund")
                return
            }
            
            let messageDate = firstMenssage.sentDate
            let dateString = ChatViewController.fecha.string(from: messageDate)
            var menssage = ""
            switch firstMenssage.kind {
                case .text(let menssageText):
                    menssage = menssageText
            case .attributedText(_), .photo(_), .video(_), .location(_), .emoji(_), .audio(_), .contact(_), .linkPreview(_), .custom(_):
                break
            }
            let conversacionId = "conversacion-\(firstMenssage.messageId)"
            let datosNuevaConversacion: [String: Any] = [
                "id": conversacionId,
                "other_user_email": otroUsuarioEmail,
                "lastest_message": [
                    "date":dateString,
                    "menssage": menssage,
                    "is_read": false
                ]
            ]
            if var conversacion = userNode["conversacion"] as? [[String: Any]]{
                conversacion.append(datosNuevaConversacion)
                userNode["conversacion"] = conversacion
                ref.setValue(userNode,withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                       return
                    }
                    self?.finalizarCreacionConversacion(with: conversacionId, firstMessage: firstMenssage, completion: completion)
                })
                
            }else {
                userNode["conversacion"] = [
                    datosNuevaConversacion
                ]
                ref.setValue(userNode, withCompletionBlock: {[weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finalizarCreacionConversacion(with: conversacionId, firstMessage: firstMenssage, completion: completion)
                })
            }
        })
    }
    // buscar y regresar conversacion para un usuario con password y email
    func getAllConversation(for email: String, completion: @escaping (Result<String,Error>) -> Void){
        
    }
    func getAllMessageForConversation(with id: String, completion: @escaping (Result<String,Error>) -> Void) {
        
    }
    func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
        
    }
}

extension ChatViewController {
    func safeEmail(con email:String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}


extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("self sender is will ...")
        return Sender(senderId: "12", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    
}
