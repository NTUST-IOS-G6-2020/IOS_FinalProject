//
//  ProfileSecondCell.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/6/23.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 70 / 255, green: 130 / 255, blue: 180 / 255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    var contentLabel: UITextField = {
        let label = UITextField()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.placeholder = "Write something..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    var editBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(UIColor.red, for: .normal)
        //btn.imageView?.image = UIImage(named: "edit")
        btn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 16)
        btn.setTitle("", for: .normal)
        btn.isEnabled = true
        //btn.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        return btn
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
        //imageView?.image = UIImage(named: "me")
        backgroundColor = UIColor.clear
        
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(editBtn)
        
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentLabel.topAnchor).isActive = true
        
        contentLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        contentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        editBtn.leftAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        editBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        editBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        editBtn.bottomAnchor.constraint(equalTo: contentLabel.topAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
