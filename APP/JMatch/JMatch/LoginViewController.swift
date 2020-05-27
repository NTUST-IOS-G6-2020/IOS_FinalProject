//
//  LoginViewController.swift
//  Tinder-chat
//
//  Created by shungfu on 2020/5/25.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var login_btn: UIButton!
    
    @IBOutlet weak var WarnText: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set up Login UI
        setupUI()
    }
    
    @IBAction func Login(_ sender: UIButton) {
        // Test Sign Up Info View
//       let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUpInfoVC")
//        navigationController?.pushViewController(vc, animated: true)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func DismissAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toSignUp(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUpVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
