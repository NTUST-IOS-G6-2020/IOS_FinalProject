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

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
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
    
    // MARK: - SET UI
    func setupUI() {
        // SingUp btn
        signup_btn.layer.cornerRadius = 22.0
        
        // TextField //
        // Email
        setTextField(TextField: txtEmail, keyboardType: .emailAddress, returnKeyType: .continue)
        // Password
        setTextField(TextField: txtPassword, keyboardType: .default, returnKeyType: .continue)
        txtPassword.isSecureTextEntry = true
        
        // Warning text
        WarnText.isHidden = true
    }
    
    func createGradientLayer(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemPink.cgColor, UIColor.orange.cgColor]
        gradientLayer.locations = [0.0, 2.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setTextField(TextField : UITextField, keyboardType: UIKeyboardType, returnKeyType: UIReturnKeyType) {
        TextField.delegate = self
        TextField.borderStyle = .roundedRect
        TextField.clearButtonMode = .whileEditing
        TextField.keyboardType = keyboardType
        TextField.returnKeyType = returnKeyType
        TextField.textColor = UIColor.systemPink
    }
    
    // MARK: - input Validate
    func checkEmptyInput(TextField: UITextField) -> Bool {
        
        guard let _ = TextField.text, TextField.text?.count != 0 else{

            return false
        }
        
        return true
    }
    
    // MARK: - UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtEmail{
            txtEmail.becomeFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
