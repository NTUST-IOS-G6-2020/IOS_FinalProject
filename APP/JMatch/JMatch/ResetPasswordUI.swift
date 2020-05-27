//
//  ResetPasswordUI.swift
//  JMatch
//
//  Created by shungfu on 2020/5/27.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

extension ResetPasswordViewController: UITextFieldDelegate {
    // MARK: - Set UI
    func setupUI (){
        // reset btn
        reset_btn.layer.cornerRadius = 30.0
        
        // TextField
        setTextField(TextField: txtEmail, keyboardType: .emailAddress, returnKeyType: .done)
        
        // Warn text
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
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
