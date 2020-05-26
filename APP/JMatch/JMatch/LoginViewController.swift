//
//  LoginViewController.swift
//  Tinder-chat
//
//  Created by shungfu on 2020/5/25.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var login_btn: UIButton!
    
    @IBOutlet weak var warnUser: UILabel!
    @IBOutlet weak var warnPassword: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set up Login UI
        setupUI()
    }
    
    @IBAction func Login(_ sender: UIButton) {
        if checkInputValidation(TextField: UserName) && checkInputValidation(TextField: Password){
            
        }
    }
    
    @IBAction func DismissAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toSignUp(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUpVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - SET UI
    func setupUI() {
        
        // Background color to be gradient
//        createGradientLayer()
        
        // login btn
        login_btn.layer.cornerRadius = 22.0
        
        // TextField //
        // Email
        setTextField(TextField: UserName, keyboardType: .emailAddress, returnKeyType: .continue)
        // Password
        Password.isSecureTextEntry = true
        setTextField(TextField: Password, keyboardType: .default, returnKeyType: .done)
        
        // Warning text
        warnUser.isHidden = true
        warnPassword.isHidden = true
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
        
        if TextField == UserName {
            warnUser.isHidden = true
            guard let email = UserName.text, UserName.text?.count != 0 else {
                warnUser.isHidden = false
                warnUser.text = "Please Enter User Email"
                return false
            }
            
            if !isValidEmail(emailID: email) {
                warnUser.isHidden = false
                warnUser.text = "Please Enter Valid Email Address"
                return false
            }
        }
        else if TextField == Password {
            warnPassword.isHidden = true
            guard let _ = Password.text, Password.text?.count != 0 else{
                       warnPassword.isHidden = false
                       warnPassword.text = "Please Enter Password"
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
        if textField == UserName{
            textField.resignFirstResponder()
            Password.becomeFirstResponder()
        }
        else if textField == Password{
            textField.resignFirstResponder()
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

}
