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
    
    var timer: Timer?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
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
        
        guard let charPartnerId = message.chatPartnerId() else{
            return
        }
        
        let ref = Database.database().reference().child("users").child(charPartnerId)
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject]
                else{
                    return
            }
            
            let user = Users()
            user.birthday = dictionary["birthday"] as? String
            user.name = dictionary["display name"] as? String
            user.email = dictionary["email"] as? String
            user.gender = dictionary["gender"] as? String
            user.image = dictionary["profileImageUrl"] as? String
            user.uid = dictionary["uid"] as? String
            
            user.uid = charPartnerId
            
            self.showChatControllerForUser(user: user)
        },withCancel:  nil)
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            performSelector(inBackground: #selector(handleLogout), with: nil)
        }
        else{
            fetchUserAndSetupNaviBarTitle()
        }
    }
    
    func fetchUserAndSetupNaviBarTitle(){
        guard let uid = Auth.auth().currentUser?.uid else{
            // handle uid not found 的情況
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["display name"] as? String
                
                let user = Users()
                user.birthday = dictionary["birthday"] as? String
                user.name = dictionary["display name"] as? String
                user.email = dictionary["email"] as? String
                user.gender = dictionary["gender"] as? String
                user.image = dictionary["profileImageUrl"] as? String
                user.uid = dictionary["uid"] as? String
                self.setupNaviBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    func setupNaviBarWithUser(user: Users){
        
        messages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        
        observerUserMesssges()
        
        let titleView = UIView()
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.image{
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        // add image constraint
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // add name constraint
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
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
    
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        
        DispatchQueue.main.async(execute: {
            let vc = WelcomeViewController()
            self.present(vc, animated: true, completion: nil)
        })
    }
    

}
