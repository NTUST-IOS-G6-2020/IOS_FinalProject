//
//  SignUpInfoViewController.swift
//  JMatch
//
//  Created by shungfu on 2020/5/26.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import Firebase

class SignUpInfoViewController: UIViewController {

    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var genderMan_btn: UIButton!
    @IBOutlet weak var genderWoman_btn: UIButton!
    @IBOutlet weak var signUp_btn: UIButton!
    
    let datePicker = UIDatePicker()
    var gender: String!
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    
    func validateFields() -> Bool {
        guard let name = txtName.text, !name.isEmpty else {
            CustomHUD().ErrorHUD(view: self.view, Message: "Please Enter an User Name")
            return false
        }
        
        guard let birthday = txtBirthday.text, !birthday.isEmpty else {
            CustomHUD().ErrorHUD(view: self.view, Message: "Please Enter your Birthday")
            return false
        }
        return true
    }
    
    @IBAction func SignUp(_ sender: Any) {
        
        guard let imageSelected = self.image else {
            CustomHUD().ErrorHUD(view: self.view, Message: "Please choose your Avatar")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            CustomHUD().ErrorHUD(view: self.view, Message: "JPEG Compression Error")
            return
        }
        
        // Get Current User
        guard let user = Auth.auth().currentUser else {
            CustomHUD().ErrorHUD(view: self.view, Message: "Current User Not Found")
            return
        }
        
        // Empty TextField
        if !validateFields() {
            return
        }
        
        print(user.uid)
        
        // Create update data
        var dict: Dictionary<String, Any> = [
            "uid": user.uid,
            "email": user.email!,
            "profileImageUrl": "",
            "birthday": txtBirthday.text!,
            "display name": txtName.text!,
            "gender": gender!
        ]
        
        // Use Storage to save Avatat data
        let storageRef = Storage.storage().reference(forURL: "gs://ntust-ios-g6-2020-b54bd.appspot.com")
        let storageProfileRef = storageRef.child("profile").child(user.uid)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // Custom Load HUD
        let load_hud = CustomHUD().LoadHUD(view: self.view)
        
        // Upload Avatar to Firebase Storage
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
            if error != nil {
                load_hud.hide(animated: true)
                CustomHUD().ErrorHUD(view: self.view, Message: error!.localizedDescription)
                return
            }
            print("ImageDone")
            
            // Get StorageProfileRef Download URL
            storageProfileRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    load_hud.hide(animated: true)
                    CustomHUD().ErrorHUD(view: self.view, Message: error!.localizedDescription)
                    return
                }
                if let metaImageUrl = url?.absoluteString{
                    dict["profileImageUrl"] = metaImageUrl
                    print(dict["profileImageUrl"]!)
                    
                    // Update data
                    Database.database().reference().child("users").child(user.uid).updateChildValues(dict) { (error, red) in
                        if error != nil{
                            load_hud.hide(animated: true)
                            CustomHUD().ErrorHUD(view: self.view, Message: error!.localizedDescription)
                            return
                        }
                        load_hud.hide(animated: true)
                        CustomHUD().SuccessHUD(view: self.view, Message: "Sign UP Success")
                    }
                    
                }
            })
        }
        // Navigation
        navigationController?.popToRootViewController(animated: true)        
    }
    
    @IBAction func GenderManCheck(_ sender: UIButton) {
        if genderMan_btn.isSelected == false{
            genderMan_btn.isSelected = !genderMan_btn.isSelected
            genderWoman_btn.isSelected = !genderWoman_btn.isSelected
            gender = genderMan_btn.titleLabel?.text
        }
    }
    
    @IBAction func GenderWoman_bnt(_ sender: UIButton) {
        if genderWoman_btn.isSelected == false{
            genderMan_btn.isSelected = !genderMan_btn.isSelected
            genderWoman_btn.isSelected = !genderWoman_btn.isSelected
            gender = genderWoman_btn.titleLabel?.text
        }
    }
    
}
