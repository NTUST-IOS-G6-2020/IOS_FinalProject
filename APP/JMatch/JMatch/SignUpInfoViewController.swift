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
    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var genderMan_btn: UIButton!
    @IBOutlet weak var genderWoman_btn: UIButton!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var signUp_btn: UIButton!
    
    
    let datePicker = UIDatePicker()
    var gender: String!
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    
    @IBAction func SignUp(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Sign Up", message: "註冊成功", preferredStyle: .alert)
        let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alert)
        present(alertController, animated: true, completion: nil)
        
        guard let imageSelected = self.image else {
            print("Avatar is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        
        // Get Current User
        if let user = Auth.auth().currentUser{
            print(user.uid)
            
            // Create update data
            var dict: Dictionary<String, Any> = [
                "uid": user.uid,
                "email": user.email,
                "profileImageUrl": "",
                "birthday": txtBirthday.text,
                "display name": txtName.text,
                "gender": gender
            ]
            
            // Use Storage to save Avatat data
            let storageRef = Storage.storage().reference(forURL: "gs://ntust-ios-g6-2020-b54bd.appspot.com")
            let storageProfileRef = storageRef.child("profile").child(user.uid)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            // Upload Avatar to Firebase Storage
            storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                print("ImageDone")
                
                // Get StorageProfileRef Download URL
                storageProfileRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error?.localizedDescription)
                        return
                    }
                    if let metaImageUrl = url?.absoluteString{
                        dict["profileImageUrl"] = metaImageUrl
                        print(dict["profileImageUrl"])
                        
                        // Update data
                        Database.database().reference().child("users").child(user.uid).updateChildValues(dict) { (error, red) in
                            if error != nil{
                                print(error?.localizedDescription)
                                return
                            }
                            print("Done")
                        }
                    }
                })
                
            }
        }
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
            gender = genderMan_btn.titleLabel?.text
        }
    }
    
}
