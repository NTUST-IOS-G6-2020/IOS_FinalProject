//
//  SignUpInfoViewController.swift
//  JMatch
//
//  Created by shungfu on 2020/5/26.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

class SignUpInfoViewController: UIViewController {

    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var genderMan_btn: UIButton!
    @IBOutlet weak var genderWoman_btn: UIButton!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var signUp_btn: UIButton!
    
    let datePicker = UIDatePicker()
    
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
    }
    
    @IBAction func GenderManCheck(_ sender: UIButton) {
        if genderMan_btn.isSelected == false{
            genderMan_btn.isSelected = !genderMan_btn.isSelected
            genderWoman_btn.isSelected = !genderWoman_btn.isSelected
        }
    }
    
    @IBAction func GenderWoman_bnt(_ sender: UIButton) {
        if genderWoman_btn.isSelected == false{
            genderMan_btn.isSelected = !genderMan_btn.isSelected
            genderWoman_btn.isSelected = !genderWoman_btn.isSelected
        }
    }
    
}
