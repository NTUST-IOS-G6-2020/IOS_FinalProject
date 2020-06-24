//
//  FriendsTableViewController.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/6/22.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import Firebase

class FriendsTableViewController: UITableViewController {

    var user: Users?
    let cellId = "cellId"
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //checkIfUserIsLoggedIn()
        self.navigationItem.title = "Friends"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ProfileViewController.canEdit = true
    }
    
    func checkIfUserIsLoggedIn(){
        guard let uid = Auth.auth().currentUser?.uid else{
            // handle uid not found 的情況
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["display name"] as? String
                
                let user = Users(dictionary: dictionary)
                
                self.user = user
                self.navigationItem.titleView = self.user?.setupNaviBarWithUser()
            }
        }, withCancel: nil)
    }
    
    
    func fetchUser(){
        let current = Auth.auth().currentUser!.uid
        
        Database.database().reference().child("matches").child(current).observe(.childAdded, with: { (snapshot)  in
            if snapshot.value as? Int == 1{
                Database.database().reference().child("users").child(snapshot.key).observe(.value, with: { (snapshot)  in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        print(dictionary)
                        let user = Users(dictionary: dictionary)
                        self.users.append(user)

                        DispatchQueue.main.async(execute: {
                          self.tableView.reloadData()
                        })
                    }
                }, withCancel: nil)
            }
        }, withCancel: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! UserCell
        // Configure the cell...
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        if user.gender == "Man"{
            cell.detailTextLabel?.text = "♂︎ " + user.birthday!
            cell.detailTextLabel?.textColor = UIColor.blue
        } else{
            cell.detailTextLabel?.text = "♀︎ " + user.birthday!
            cell.detailTextLabel?.textColor = UIColor.red
        }
        
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
            let mainstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileController = mainstoryboard.instantiateViewController(identifier: "profile") as ProfileViewController
           // let profileController = mainstoryboard.instantiateViewController(identifier: "profileNavi")
            ProfileViewController.user = user
            ProfileViewController.canEdit = false

//            self.navigationController?.pushViewController(profileController, animated: true)
            let naviController = UINavigationController(rootViewController: profileController)
            self.present(naviController, animated: true, completion: nil)
        })
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
