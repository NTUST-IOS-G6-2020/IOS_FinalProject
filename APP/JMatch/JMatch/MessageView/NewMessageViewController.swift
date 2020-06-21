//
//  NewMessageViewController.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/6/20.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UITableViewController {
    let cellId = "cellId"
    var users = [Users]()
    var messageController: MessageTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot)  in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = Users()
                //user.setValuesForKeys(dictionary)
                user.birthday = dictionary["birthday"] as? String
                user.name = dictionary["display name"] as? String
                user.email = dictionary["email"] as? String
                user.gender = dictionary["gender"] as? String
                user.image = dictionary["profileImageUrl"] as? String
                user.uid = dictionary["uid"] as? String
                
                self.users.append(user)
                
                DispatchQueue.main.async(execute: {
                  self.tableView.reloadData()
                })
            }
            
            //print(snapshot)
        }, withCancel: nil)
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! UserCell
        // Configure the cell...
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.image{
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: {
            let user = self.users[indexPath.row]
            self.messageController?.showChatControllerForUser(user: user)
        })
    }
    
}
