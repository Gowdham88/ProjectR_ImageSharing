//
//  TextScroll.swift
//  SarvodayaHB
//
//  Created by CZ Ltd on 1/30/18.
//  Copyright © 2018 CZ Ltd. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import Alamofire
import Nuke

class TextScroll: UIViewController, UITextViewDelegate {
    
//    @IBOutlet weak var label1: UILabel!
//    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var privPolicy: UILabel!
    @IBOutlet weak var policyImg: UIButton!
    @IBOutlet weak var privacyView: UIView!
    
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var termLbl: UILabel!
    @IBOutlet weak var termImg: UIButton!
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var shareImg: UIImageView!
    
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logLbl: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var protectionView: UIView!
    @IBOutlet weak var protectLbl: UILabel!
    @IBOutlet weak var protBtn: UIButton!
    
    var transferImg: UIImage!
    var users = [Users]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        userDetails()
        profileImg.image = transferImg
        print("My image retrive",profileImg.image)
        
        //Navigation title heading - colour setting:-
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //profile image circle view:--
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
//        profileImg.layer.borderWidth = 2
//        profileImg.layer.borderColor = UIColor.black.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TextScroll.tappedMe))
        profileImg.addGestureRecognizer(tap)
        profileImg.isUserInteractionEnabled = true
        
        
//        textView.delegate = self
//        textView.scrollsToTop = true
//        let point = CGPoint(x: 0.0, y: (textView.contentSize.height - textView.bounds.height))
//        textView.setContentOffset(point, animated: true)
//        let range = NSMakeRange(textView.text.characters.count - 1, 0)
//        textView.scrollRangeToVisible(range)
        // Do any additional setup after loading the view.
        
//        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(show(_:sender:)))
//        navigationController?.navigationBar.topItem?.rightBarButtonItem = add
        
    }
    
    func userDetails() {
        
        
        API.User.observeCurrentUser { (user) in
            
        
            
            if let profileurl = user.profileImageURL{
                
                self.profileImg.image = nil
                if profileurl != "" {
                    
                    Manager.shared.loadImage(with: URL(string: profileurl)!, into: self.profileImg)
                }
            }
            
         
            if self.userName.text != nil {
                
                self.userName.text = user.username
                
            }
            
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func tappedMe()
    {
        print("Tapped on Image")

    }
    
   
    @IBAction func BtnBack(_ sender: UIBarButtonItem) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func protectionTap(_ sender: Any) {
        
    }
    @IBAction func policyTap(_ sender: Any) {
        
        print("Policy button tapped")
        
    }
    @IBAction func termsTap(_ sender: Any) {
        
         print("Terms button tapped")
        
    }
    @IBAction func shareTap(_ sender: Any) {
        
         print("Share button tapped")
        
    }
    @IBAction func logoutTap(_ sender: Any) {
        
         print("Logout button tapped")
        
        //Logging out from firebase:
        AuthService.signOut(onSuccess: {
            // Present the Sign In VC
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
            self.present(signInVC, animated: true)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
        
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        print("Back btn tapped")
        tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
        

    }
    
    
}
