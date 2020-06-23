//
//  MatchViewController.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/6/22.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import Firebase

class MatchViewController: UIViewController {

    
    //MARK: - Properties
    var viewModelData = [CardsDataModel]()
    var stackContainer : StackContainerView!
    var SearchBtn:  UIButton!
    
    //MARK: - Init
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1.0)
        stackContainer = StackContainerView()
        view.addSubview(stackContainer)
        configureStackContainer()
        
        SearchBtn = UIButton()
        stackContainer.addSubview(SearchBtn)
        configureSearchBtn()
        
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        SearchBtn.translatesAutoresizingMaskIntoConstraints = false
        SearchBtn.setTitleColor(UIColor.lightGray, for: .normal)
        SearchBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 30)
        SearchBtn.setTitle("Search", for: .normal)
        SearchBtn.layer.borderColor = UIColor.lightGray.cgColor
        SearchBtn.layer.borderWidth = 1
        SearchBtn.layer.cornerRadius = 16
        SearchBtn.isEnabled = true
        SearchBtn.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        //configureNavigationBarButtonItem()
    }
    

    //MARK: - Configurations
    func configureStackContainer() {
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        stackContainer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    func configureSearchBtn(){
        SearchBtn.centerXAnchor.constraint(equalTo: stackContainer.centerXAnchor).isActive = true
        SearchBtn.centerYAnchor.constraint(equalTo: stackContainer.centerYAnchor).isActive = true
        SearchBtn.widthAnchor.constraint(equalTo: stackContainer.widthAnchor).isActive = true
        SearchBtn.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func configureNavigationBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(resetTapped))
    }
    
    //MARK: - Handlers
    @objc func resetTapped() {
        stackContainer.reloadData()
        navigationItem.rightBarButtonItem?.isEnabled = false
        //fetchUser()
        SearchBtn.isEnabled = false
        SearchBtn.isHidden = true
    }
    
    var user: Users?
    var users = [Users]()
    
    var divisor: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        divisor = (view.frame.width / 2) / 0.61
        
        // checkIfUserIsLoggedIn()
        self.navigationItem.title = "Match"
        
        fetchUser()
        
        stackContainer.dataSource = self
        
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func checkIfUserIsLoggedIn(){
        guard let uid = Auth.auth().currentUser?.uid else{
            // handle uid not found 的情況
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["display name"] as? String
                
                let user = Users(dictionary: dictionary)
                
                self.user = user
                self.navigationItem.titleView = self.user?.setupNaviBarWithUser()
            }
        }, withCancel: nil)
    }
    
    func fetchUser(){
        let current = Auth.auth().currentUser!.uid
        let checkRef = Database.database().reference().child("matches").child(current)
        
        self.viewModelData.removeAll()
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot)  in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = CardsDataModel(dictionary: dictionary)

                if user.uid != current {
                    checkRef.child(user.uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                        if !snapshot.exists(){
                            self.viewModelData.append(user)
                        }
                    })
                }
            }
            //print(snapshot)
        }, withCancel: nil)
    }

    
}

extension MatchViewController : SwipeCardsDataSource {

    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }
    
    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = viewModelData[index]
        return card
    }
    
    func emptyView() -> UIView? {
        return nil
    }
    

}
