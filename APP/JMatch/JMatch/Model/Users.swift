//
//  Users.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/6/20.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

class Users: NSObject {
    var birthday: String?
    var name: String?
    var email: String?
    var gender: String?
    var image: String?
    var uid: String?
    
    init(dictionary: [String: AnyObject]) {
        birthday = dictionary["birthday"] as? String
        name = dictionary["display name"] as? String
        email = dictionary["email"] as? String
        gender = dictionary["gender"] as? String
        image = dictionary["profileImageUrl"] as? String
        uid = dictionary["uid"] as? String
    }
    
    func setupNaviBarWithUser() -> UIView{
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
        if let profileImageUrl = self.image{
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
        nameLabel.text = self.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // add name constraint
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        return titleView
    }
}
