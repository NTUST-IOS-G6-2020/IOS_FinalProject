//
//  SwipeCardView.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/6/22.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import Firebase

class SwipeCardView : UIView {
   
    //MARK: - Properties
    var swipeView : UIView!
    var shadowView : UIView!
    var imageView: UIImageView!
  
    var label = UILabel()
    var thumbView: UIImageView!
    
    var delegate : SwipeCardsDelegate?

    var divisor : CGFloat = 0
    let baseView = UIView()
    
    var dataSource : CardsDataModel? {
        didSet {
            if dataSource?.gender == "Woman"{
                swipeView.backgroundColor = UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1)
            } else{
                swipeView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1)
            }
            label.text = dataSource?.name
            guard let image = dataSource?.image else { return }
            imageView.loadImageUsingCacheWithUrlString(urlString: image)
        }
    }
    
    //MARK: - Init
     override init(frame: CGRect) {
        super.init(frame: .zero)
        configureShadowView()
        configureSwipeView()
        configureLabelView()
        configureImageView()
        configureThumbView()
        addPanGestureOnCards()
        configureTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    
    func configureShadowView() {
        shadowView = UIView()
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 4.0
        addSubview(shadowView)
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        shadowView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    func configureSwipeView() {
        swipeView = UIView()
        swipeView.layer.cornerRadius = 15
        swipeView.clipsToBounds = true
        shadowView.addSubview(swipeView)
        
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        swipeView.leftAnchor.constraint(equalTo: shadowView.leftAnchor).isActive = true
        swipeView.rightAnchor.constraint(equalTo: shadowView.rightAnchor).isActive = true
        swipeView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        swipeView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
    }
    
    func configureLabelView() {
        swipeView.addSubview(label)
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Chalkboard SE", size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: swipeView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: swipeView.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
    }
    
    func configureImageView() {
        imageView = UIImageView()
        swipeView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.centerXAnchor.constraint(equalTo: swipeView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: swipeView.centerYAnchor, constant: -30).isActive = true
        imageView.widthAnchor.constraint(equalTo: swipeView.widthAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: swipeView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: label.topAnchor).isActive = true
        //imageView.heightAnchor.constraint(equalTo:).isActive = true
    }
    
    func configureThumbView() {
        thumbView = UIImageView()
        swipeView.addSubview(thumbView)
        thumbView.contentMode = .scaleAspectFit
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        thumbView.alpha = 0

        thumbView.centerXAnchor.constraint(equalTo: swipeView.centerXAnchor).isActive = true
        thumbView.centerYAnchor.constraint(equalTo: swipeView.centerYAnchor, constant: -30).isActive = true
        thumbView.widthAnchor.constraint(equalTo: swipeView.widthAnchor).isActive = true
        thumbView.topAnchor.constraint(equalTo: swipeView.topAnchor).isActive = true
        thumbView.bottomAnchor.constraint(equalTo: label.topAnchor).isActive = true
    }

    func configureTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    
    func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    
    
    //MARK: - Handlers
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        let card = sender.view as! SwipeCardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        //let distanceFromCenter = ((UIScreen.main.bounds.width / 2) - card.center.x)
        divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
        
        let xFromCenter = card.center.x - (UIScreen.main.bounds.width / 2)
        
        if xFromCenter > 30 {
            thumbView.image = UIImage(systemName: "hand.thumbsup.fill")
            thumbView.tintColor = UIColor.blue
            thumbView.alpha = abs(xFromCenter) / window!.center.x
        } else if xFromCenter < -150{
            thumbView.image = UIImage(systemName: "hand.thumbsdown.fill")
            thumbView.tintColor = UIColor.red
            thumbView.alpha = abs(xFromCenter) / window!.center.x
        }
       
        switch sender.state {
        case .ended:
            if (card.center.x) > 400 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                
                updateUserLike()
                return
            }else if card.center.x < -65 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.thumbView.alpha = 0
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            
        default:
            break
        }
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer){
    }
    
    func updateUserLike(){
        let fromId = Auth.auth().currentUser!.uid
        let toId = dataSource!.uid!
        let MatchUserRef = Database.database().reference().child("matches")
        
        MatchUserRef.child(toId).child(fromId).observeSingleEvent(of: .value, with: {(snapshot) in
            print(snapshot)
            if snapshot.exists(){
                print("yes there exists")
                MatchUserRef.child(fromId).updateChildValues([String(toId): true])
                MatchUserRef.child(toId).updateChildValues([String(fromId): true])
            
            }
            else{
                print("no")
                MatchUserRef.child(fromId).updateChildValues([String(toId): false])
            }
        },withCancel: nil)
    }
  
}
