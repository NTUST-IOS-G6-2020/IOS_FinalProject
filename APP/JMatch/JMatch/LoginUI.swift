//
//  LoginUI.swift
//  JMatch
//
//  Created by shungfu on 2020/5/27.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

extension LoginViewController: UITextFieldDelegate  {
    
    // MARK: - SET UI
    func setupUI() {
        // login btn
        login_btn.layer.cornerRadius = 22.0
        
        // TextField //
        // Email
        setTextField(TextField: UserName, keyboardType: .emailAddress, returnKeyType: .continue)
        // Password
        Password.isSecureTextEntry = true
        setTextField(TextField: Password, keyboardType: .default, returnKeyType: .done)
        
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
    
    // MARK: - UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == UserName{
            textField.resignFirstResponder()
            Password.becomeFirstResponder()
        }
        else if textField == Password{
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
