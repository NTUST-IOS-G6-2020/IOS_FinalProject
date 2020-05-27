//
//  CustomHUD.swift
//  JMatch
//
//  Created by shungfu on 2020/5/27.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import MBProgressHUD

class CustomHUD {
    func ErrorHUD(view: UIView, Message: String) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.customView
        hud.customView = UIImageView(image: UIImage(systemName: "xmark.circle"))
        hud.customView?.tintColor = UIColor.red
        hud.label.text = Message
        hud.hide(animated: true, afterDelay: 1)
    }
    
    func SuccessHUD(view: UIView, Message: String) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.customView
        hud.customView = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        hud.customView?.tintColor = UIColor.systemGreen
        hud.label.text = Message
        hud.hide(animated: true, afterDelay: 1)
    }
    
    func LoadHUD (view: UIView) -> MBProgressHUD{
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        return hud
    }
    
}
