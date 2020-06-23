//
//  Cards.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/6/22.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
struct CardsDataModel {
    
    var name: String?
    var gender: String?
    var image: String?
    var uid: String?
    
    init(dictionary: [String: AnyObject]) {
        name = dictionary["display name"] as? String
        gender = dictionary["gender"] as? String
        image = dictionary["profileImageUrl"] as? String
        uid = dictionary["uid"] as? String
    }
    
}
