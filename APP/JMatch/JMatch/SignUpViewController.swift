//
//  SignUpViewController.swift
//  Tinder-chat
//
//  Created by shungfu on 2020/5/25.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

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
    
    // MARK: - TO Firebase
    var uid = ""
    
    @IBAction func CreateAccount(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            
            if error == nil {
                if let user = Auth.auth().currentUser{
                    self.uid = user.uid
                }
            Database.database().reference(withPath:"ID/\(self.uid)/Profile/Safety-Check").setValue("ON")
                print("You have successfully signed up")
                //Goes to the Setup page which lets the user take a photo for theirprofilepicture and also chose a username
                let vc = UIStoryboard(name: "Main",bundle:nil).instantiateViewController(withIdentifier: "SignUpInfoVC")
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let alertController = UIAlertController(title: "Error",message:error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail:
                        print("invalid email")
                    case .emailAlreadyInUse:
                        print("in use")
                    default:
                        print("Create User Error: \(error!)")
                    }
                }
            }
        }
    }
    
    
    
}
