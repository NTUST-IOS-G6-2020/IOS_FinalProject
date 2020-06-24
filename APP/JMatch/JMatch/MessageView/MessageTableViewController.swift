//
//  MessageTableViewController.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/5/27.
//  Copyright © 2020 IOS-G6. All rights reserved.
//
import UIKit
import Firebase

class MessageTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var messages = [Message]()
    var messageDictionary = [String: Message]()
    
    var user: Users?
    
    var timer: Timer?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "edit")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func observerUserMesssges(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: {(snapshot) in
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId: messageId)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    private func fetchMessageWithMessageId(messageId: String){
        let messageRef = Database.database().reference().child("messages").child(messageId)
        
        messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let message = Message(dictionary: dictionary)
                        
                if let chatPartnerId = message.chatPartnerId(){
                    self.messageDictionary[chatPartnerId] = message
                    self.messages = Array(self.messageDictionary.values)
                }
                self.attempReloadOfTable()
            }
        }, withCancel: nil)
    }
    
    private func attempReloadOfTable(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable(){
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func observeMessages(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let message = Message(dictionary: dictionary)
                
                if let toID = message.toID{
                    self.messageDictionary[toID] = message
                    self.messages = Array(self.messageDictionary.values)
                }
                
                DispatchQueue.main.async(execute: {
                  self.tableView.reloadData()
                })
            }
            
        },withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else{
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject]
                else{
                    return
            }
            
            let user = Users(dictionary: dictionary)
            user.uid = chatPartnerId
            
            self.showChatControllerForUser(user: user)
        },withCancel:  nil)
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            return
        }
        else{
            fetchUserAndSetupNaviBarTitle()
            let ref = Database.database().reference().child("profile").child(Auth.auth().currentUser!.uid)
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() == false{
                    ref.updateChildValues(["bother": ""])
                    ref.updateChildValues(["enjoy": ""])
                    ref.updateChildValues(["likecountry": ""])
                    ref.updateChildValues(["relation": ""])
                    ref.updateChildValues(["school": ""])
                }else{
                    print("noooooo")
                }
            })
        }
    }
    
    func fetchUserAndSetupNaviBarTitle(){
        messages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        
        observerUserMesssges()
        self.navigationItem.title = "Message"
    }
    
    @objc func showChatControllerForUser(user: Users){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func handleNewMessage(){
        let newMessageController = NewMessageViewController()
        newMessageController.messageController = self
        let naviController = UINavigationController(rootViewController: newMessageController)
        present(naviController, animated: true, completion: nil)
    }
    

}
