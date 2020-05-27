//
//  ResetPasswordViewController.swift
//  Tinder-chat
//
//  Created by shungfu on 2020/5/26.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import Firebase

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

    @IBAction func ResetPassword(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: txtEmail.text!) { (error) in
            var title = ""
            var message = ""
            
            if error == nil {
                title = "Success!"
                message = "Password reset email sent."
                self.txtEmail.text = ""
                
            } else {
                title = "Error!"
                message = (error?.localizedDescription)!
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
