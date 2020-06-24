//
//  WelcomeViewController.swift
//  Tinder-chat
//
//  Created by shungfu on 2020/5/25.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var signup_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        login_btn.layer.cornerRadius = 30.0
        signup_btn.layer.cornerRadius = 30.0
        
        // Get Current User, if get it then login
        if let _ = Auth.auth().currentUser {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarVC")
            self.navigationController?.pushViewController(vc, animated: false)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
    }
    
    func createGradientLayer(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemPink.cgColor, UIColor.systemOrange.cgColor]
        gradientLayer.locations = [0.0, 2.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
