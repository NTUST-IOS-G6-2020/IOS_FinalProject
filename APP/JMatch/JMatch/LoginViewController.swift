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
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var WarnText: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set up Login UI
        setupUI()
    }
    
    @IBAction func DismissAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toSignUp(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUpVC")
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
        
    @IBAction func Login(_ sender: UIButton) {
        self.view.endEditing(true)
        if validateFields(){
            // Custom Load HUD
            let load_hud = CustomHUD().LoadHUD(view: self.view)
            Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
                load_hud.hide(animated: true)
                if error != nil{
                    CustomHUD().ErrorHUD(view: self.view, Message: error!.localizedDescription)
                }
                
                // Login in to New MainScene
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainVC")
//                present(vc, animated: true, completion: nil)
                
                self.navigationController?.popToRootViewController(animated: false)
                // Clear Navigation
//                self.navigationController?.viewControllers.removeAll()
            }
        }
        
    }
        
}
