//
//  ResetPasswordViewController.swift
//  Tinder-chat
//
//  Created by shungfu on 2020/5/26.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var reset_btn: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    @IBAction func DismissAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
