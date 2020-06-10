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
    
    func validateFields() -> Bool {
        guard let email = txtEmail.text, !email.isEmpty else {
            CustomHUD().ErrorHUD(view: self.view, Message: "Please Enter an Email Address")
            return false
        }
        return true
    }

    @IBAction func ResetPassword(_ sender: UIButton) {
        if validateFields() {
            Auth.auth().sendPasswordReset(withEmail: txtEmail.text!) { (error) in
                if error != nil {
                    CustomHUD().ErrorHUD(view: self.view, Message: error!.localizedDescription)
                    return
                }
                self.txtEmail.text = ""
                CustomHUD().SuccessHUD(view: self.view, Message: "Send!")
            }
        }
    }
    
}
