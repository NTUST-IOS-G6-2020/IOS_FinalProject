//
//  SignUpInfoUI.swift
//  JMatch
//
//  Created by shungfu on 2020/5/27.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

// MARK: - Extension UIAlertAction
extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}

extension SignUpInfoViewController {
    // MARK: - SET UI
    func setUI() {
        // Gender Button
        genderMan_btn.isSelected = true
        genderWoman_btn.isSelected = false
        gender = genderMan_btn.titleLabel?.text
        
        // Avatar
        setAvatar()
        
        // Name
        txtName.clearButtonMode = .whileEditing
        txtName.delegate = self
        
        // Sign up btn
        signUp_btn.layer.cornerRadius = 25
        
        // Date Picker
        txtBirthday.delegate = self
        showDatePicker()
    }
    
    // MARK: - BIRTHDAY PICKER
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date

        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.backgroundColor = .white
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        txtBirthday.inputAccessoryView = toolbar
        txtBirthday.inputAccessoryView?.backgroundColor = .white
        txtBirthday.inputView?.backgroundColor = .white
        txtBirthday.inputView = datePicker
    }

    @objc func donedatePicker(){
        let dateValue = DateFormatter()
        dateValue.dateFormat = "MM/dd/yyyy"
        txtBirthday.text = dateValue.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - SET AVATAR
    func setAvatar () {
        Avatar.layer.cornerRadius = 70
        Avatar.clipsToBounds = true
        Avatar.contentMode = .scaleAspectFill
        Avatar.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        Avatar.addGestureRecognizer(tapGesture)
    }

    @objc func presentPicker() {
        let photoSourceRequestController = UIAlertController(title: "", message: "選擇加入圖片方式", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "相機", style: .default) { (action) in
            // Custom Load HUD
            let load_hud = CustomHUD().LoadHUD(view: self.view)
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                // Extension to change Photo
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                
                load_hud.hide(animated: true)
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let photoLibAction = UIAlertAction(title: "圖片庫", style: .default) { (action) in
            // Custom Load HUD
            let load_hud = CustomHUD().LoadHUD(view: self.view)
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                // Extension to change Photo
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                
                load_hud.hide(animated: true)
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        cancleAction.titleTextColor = UIColor.red
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibAction)
        photoSourceRequestController.addAction(cancleAction)
        
        present(photoSourceRequestController, animated: true, completion: nil)
    }
}


// MARK:- Extension UIImagePickerController
extension SignUpInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = editImage
            Avatar.image = editImage
        }
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image = selectedImage
            Avatar.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extension UITextField
extension SignUpInfoViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) ->Bool {
        // Textfields cannot input, edit by the keyboard. It just can set text by code.
        if textField == txtBirthday{
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

