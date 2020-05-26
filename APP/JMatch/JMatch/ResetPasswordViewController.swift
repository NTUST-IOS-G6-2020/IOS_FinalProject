//
//  ResetPasswordViewController.swift
//  Tinder-chat
//
//  Created by shungfu on 2020/5/26.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var reset_btn: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var warnEmail: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    @IBAction func DismissAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toLogin(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func toSignUP(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUpVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Set UI
    func setupUI (){
        // reset btn
        reset_btn.layer.cornerRadius = 30.0
        
        // TextField
        setTextField(TextField: txtEmail, keyboardType: .emailAddress, returnKeyType: .done)
        
        // Warn text
        warnEmail.isHidden = true
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
        
        if TextField == txtEmail {
            warnEmail.isHidden = true
            guard let email = txtEmail.text, warnEmail.text?.count != 0 else {
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
