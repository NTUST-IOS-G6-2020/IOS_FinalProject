//
//  MessageTableViewCell.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/5/27.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var userImgView: UIImageView! {
        didSet{
            userImgView.layer.cornerRadius = userImgView.bounds.width / 2
            userImgView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
