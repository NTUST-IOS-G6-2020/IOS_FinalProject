//
//  Chat.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/6/17.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

struct Chat {
    
    var users: [String]
    
    var dictionary: [String: Any] {
        return [
            "users": users
        ]
    }
}

extension Chat {
    
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
    
}
