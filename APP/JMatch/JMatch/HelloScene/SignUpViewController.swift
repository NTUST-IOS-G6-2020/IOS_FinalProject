//
//  SignUpViewController.swift
//  Tinder-chat
//
//  Created by shungfu on 2020/5/25.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var signup_btn: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var WarnText: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set up Login UI
        setupUI()
    }
    
    @IBAction func DismissAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toLogin(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func validateFields() -> Bool {
        guard let email = txtEmail.text, !email.isEmpty else {
            CustomHUD().ErrorHUD(view: self.view, Message: "Please Enter an Email Address")
            return false
        }
        
        guard let password = txtPassword.text, !password.isEmpty else {
            CustomHUD().ErrorHUD(view: self.view, Message: "Please Enter your Password")
            return false
        }
        return true
    }
    
    @IBAction func CreateAccount(_ sender: UIButton) {
        self.view.endEditing(true)
        if validateFields() {
            
            let load_hud = CustomHUD().LoadHUD(view: self.view)
            Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) {
                (user, error) in
                // Hide Custom Load HUD
                load_hud.hide(animated: true)
                if error == nil {
                    // Show the Setup page which lets the user take a photo for theirprofilepicture and also chose      username
                    let vc = UIStoryboard(name: "Main",bundle:nil).instantiateViewController(withIdentifier: "SignUpInfoVC")
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    CustomHUD().ErrorHUD(view: self.view, Message: error!.localizedDescription)
                }
            }
        }
    }
    
}
