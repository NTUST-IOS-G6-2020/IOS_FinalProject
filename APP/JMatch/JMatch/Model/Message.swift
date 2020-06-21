//
//  Message.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/6/21.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromID: String?
    var toID: String?
    var timestamp: String?
    var text: String?
    
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    func chatPartnerId() -> String?{
        if fromID == Auth.auth().currentUser?.uid{
            return toID
        } else{
            return fromID
        }
    }
    
    init(dictionary: [String: AnyObject]){
        super.init()
        
        fromID = dictionary["fromID"] as? String
        toID = dictionary["toID"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
    }
}
