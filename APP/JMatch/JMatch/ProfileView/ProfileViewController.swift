//
//  ProfileViewController.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/6/23.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var friendViewController: FriendsTableViewController?
    static var user: Users? 
    var profiledictionary = [String: String]()
    
    @IBOutlet weak var ProfileTable: UITableView!

    @IBOutlet weak var DisplayName: UITextField!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    var txt = [String: String]()
    static var canEdit: Bool = true
    
    var noValue: Bool = true
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let key = textField.accessibilityIdentifier!
        let value = textField.text!
        if key != "display"{
            txt[key] = value
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProfileTable.dequeueReusableCell(withIdentifier: "Profile", for: indexPath) as! ProfileCell
        cell.contentLabel.delegate = self
        
        var cnt = 0
        
        if ProfileViewController.canEdit == false{
            cell.contentLabel.isEnabled = false
        }

        if txt.isEmpty == true && cnt < 10{
            cnt = cnt + 1
            observeProfileContent()
        }
        
        if indexPath.section == 0{
            cell.titleLabel.text = "學校"
            //cell.contentLabel.text = txt["school"]
            cell.contentLabel.accessibilityIdentifier = "school"
        } else if indexPath.section == 1{
            cell.titleLabel.text = "興趣"
            //cell.contentLabel.text = txt["enjoy"]
            cell.contentLabel.accessibilityIdentifier = "enjoy"
        } else if indexPath.section == 2{
            cell.titleLabel.text = "感情狀態"
            //cell.contentLabel.text = txt["relation"]
            cell.contentLabel.accessibilityIdentifier = "relation"
        }
        else if indexPath.section == 3{
            cell.titleLabel.text = "最近的困擾"
            //cell.contentLabel.text = txt["bother"]
            cell.contentLabel.accessibilityIdentifier = "bother"
        }
        
        txt.forEach({(element) in
            if cell.contentLabel.accessibilityIdentifier == element.key{
                cell.contentLabel.text = element.value
            }
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view.
        //ProfileTable = UITableView(
        
        ProfileTable.register(ProfileCell.self, forCellReuseIdentifier: "Profile")
        ProfileTable.delegate = self
        ProfileTable.dataSource = self
        ProfileTable.keyboardDismissMode = .interactive
        
        DisplayName.delegate = self
        DisplayName.accessibilityIdentifier = "display"
        if ProfileViewController.canEdit == false{
            DisplayName.isEnabled = false
        }
        
        checkIfUserIsLoggedIn()
        
        setProfileImg()
        
        observeProfileContent()
        
        if ProfileViewController.canEdit == false{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        } else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        }
        
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave(){
        //ProfileTable.dataSource?.tableView(ProfileTable, cellForRowAt: IndexPath)
        
        guard let uid = Auth.auth().currentUser?.uid else{
            // handle uid not found 的情況
            return
        }
        
        let ref =  Database.database().reference().child("profile").child(uid)
        
        self.txt.forEach({(element) in
            print(element)
            ref.updateChildValues([String(element.key): element.value])
        })
        
        let userRef = Database.database().reference().child("users").child(uid)
        userRef.updateChildValues(["display name": String(self.DisplayName.text!)])
    }
    
    func observeProfileContent(){
        guard var uid = Auth.auth().currentUser?.uid else{
            // handle uid not found 的情況
            return
        }
        
        if ProfileViewController.canEdit == false{
            uid = ProfileViewController.user!.uid!
        }
        
        Database.database().reference().child("profile").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                dictionary.forEach({(element) in
                    self.txt[element.key] = (element.value as! String)
                })
                self.noValue = false
            }
        })
        
        self.ProfileTable.reloadData()
    }
    
    func checkIfUserIsLoggedIn(){
        guard var uid = Auth.auth().currentUser?.uid else{
            // handle uid not found 的情況
            return
        }
        
        if ProfileViewController.user?.uid != nil {
            let new = ProfileViewController.user!.uid!
            uid = new
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //self.navigationItem.title = dictionary["display name"] as? String
                self.navigationItem.title = "Profile"
                let user = Users(dictionary: dictionary)
                
                ProfileViewController.self.user = user
                self.ProfileImage.loadImageUsingCacheWithUrlString(urlString: user.image!)
                self.DisplayName.text = user.name
            }
        }, withCancel: nil)
    }
    
    func setProfileImg(){
        
        self.ProfileImage.translatesAutoresizingMaskIntoConstraints = false
        self.ProfileImage.layer.masksToBounds = true
        self.ProfileImage.layer.cornerRadius = 75
        self.ProfileImage.contentMode = .scaleAspectFill
        self.ProfileImage.layer.borderColor = UIColor(red: 70 / 255, green: 130 / 255, blue: 180 / 255, alpha: 0.5).cgColor
        self.ProfileImage.layer.borderWidth = 3
        self.ProfileImage.isUserInteractionEnabled = true
        self.ProfileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentPicker)))
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
        
        print(ProfileViewController.canEdit)
        if ProfileViewController.canEdit == true{
            present(photoSourceRequestController, animated: true, completion: nil)
        }
        //present(photoSourceRequestController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            ProfileImage.image = editImage
        }
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{            ProfileImage.image = selectedImage
        }
        
        if let selectedImage = ProfileImage.image{
            uploadToFireStorageUsingImage(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadToFireStorageUsingImage(image: UIImage){
        let current = Auth.auth().currentUser!.uid
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("profile").child(imageName)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let load_hud = CustomHUD().LoadHUD(view: self.view)
        
        if let uploadData = image.jpegData(compressionQuality: 0.2){
            ref.putData(uploadData, metadata: metaData, completion: {(metadata, error) in
                if error != nil{
                    print(error as Any)
                    return
                }
                
                ref.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error as Any)
                        return
                    }
                    if let metaImageUrl = url?.absoluteString{
                        // Update data
                        Database.database().reference().child("users").child(current).updateChildValues(["profileImageUrl": metaImageUrl]) { (error, red) in
                            if error != nil{
                                load_hud.hide(animated: true)
                                CustomHUD().ErrorHUD(view: self.view, Message: error!.localizedDescription)
                                return
                            }
                            load_hud.hide(animated: true)
                        }
                    }
                })
            })
        }
    }

}
