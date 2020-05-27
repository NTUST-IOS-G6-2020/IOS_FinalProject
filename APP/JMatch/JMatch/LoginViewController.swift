//
//  LoginViewController.swift
//  Tinder-chat
//
//  Created by shungfu on 2020/5/25.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import Firebase

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
        self.view.endEditing(true)
        
        Auth.auth().signIn(withEmail: UserName.text!, password: Password.text!) { (user, error) in
            if error == nil{
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainVC")
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                // Error
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func DismissAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toSignUp(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUpVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
