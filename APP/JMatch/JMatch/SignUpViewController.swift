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
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCheckPassword: UITextField!
    
    @IBOutlet weak var warnName: UILabel!
    @IBOutlet weak var warnEmail: UILabel!
    @IBOutlet weak var warnPassword: UILabel!
    @IBOutlet weak var warnCheckPassword: UILabel!
    
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
    
    // MARK: - SET UI
    func setupUI() {
        
        // Background color to be gradient
//        createGradientLayer()
        
        // SingUp btn
        signup_btn.layer.cornerRadius = 22.0
        
        // TextField //
        // UserName
        setTextField(TextField: txtName, keyboardType: .default, returnKeyType: .continue)
        // Email
        setTextField(TextField: txtEmail, keyboardType: .emailAddress, returnKeyType: .continue)
        // Password
        setTextField(TextField: txtPassword, keyboardType: .default, returnKeyType: .continue)
        txtPassword.isSecureTextEntry = true
        // Confirm Password
        setTextField(TextField: txtCheckPassword, keyboardType: .default, returnKeyType: .done)
        txtCheckPassword.isSecureTextEntry = true
        
        // Warning text
        warnName.isHidden = true
        warnEmail.isHidden = true
        warnPassword.isHidden = true
        warnCheckPassword.isHidden = true
        
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
    func checkInputValidation(TextField: UITextField) -> Bool {
        
        // Check Email
        if TextField == txtEmail {
            warnEmail.isHidden = true
            guard let email = txtEmail.text, txtEmail.text?.count != 0 else {
                warnEmail.isHidden = false
                warnEmail.text = "Please Enter User Email"
                return false
            }
            
            if !isValidEmail(emailID: email) {
                warnEmail.isHidden = false
                warnEmail.text = "Please Enter Valid Email Address"
                return false
            }
        }
        // Check Confirm Password
        else if TextField == txtCheckPassword{
            warnCheckPassword.isHidden = true
            guard let _ = txtCheckPassword.text, txtCheckPassword.text?.count != 0 else {
                warnCheckPassword.isHidden = false
                warnCheckPassword.text = "Please Enter Confirm Password"
                return false
            }
        }
        // Check Password
        else if TextField == txtPassword {
            warnPassword.isHidden = true
            guard let _ = txtPassword.text, txtPassword.text?.count != 0 else{
                warnPassword.isHidden = false
                warnPassword.text = "Please Enter Password"
                return false
            }
        }
        // Check Name
        else if TextField == txtName {
            warnName.isHidden = true
            guard let _ = txtName.text, txtName.text?.count != 0 else{
                warnName.isHidden = false
                warnName.text = "Please Enter User Name"
                return false
            }
        }
        return true
    }
    
    func isValidEmail(emailID: String) -> Bool{
        let emailRegEx = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    // MARK: - UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtName{
            txtEmail.becomeFirstResponder()
        }
        else if textField == txtEmail{
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword{
            txtCheckPassword.becomeFirstResponder()
        }
        checkInputValidation(TextField: textField)
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - TO Firebase
    
    var uid = ""
    
    @IBAction func CreateAccount(_ sender: UIButton) {
        if txtEmail.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)

        }
        else {
            Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
                
                if error == nil {
                    if let user = Auth.auth().currentUser{
                        self.uid = user.uid
                    }
                    Database.database().reference(withPath: "ID/\(self.uid)/Profile/Safety-Check").setValue("ON")
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
