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

class ChatViewController: MessagesViewController {
    var messages = [Message]()
    var selfSender = Sender(senderId: "1", displayName: "Persona")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hola persona")))
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Como estas")))

        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    
}
