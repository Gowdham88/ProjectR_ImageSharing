//
//  UserdetailPage.swift
//  Project_R
//
//  Created by CZSM G on 21/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import Alamofire
import Nuke

class UserdetailPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    var numOfRow = 0
    var transferImg: UIImage!


    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var userName: UILabel!

    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var assetCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    
    @IBOutlet weak var assetLbl: UILabel!
    @IBOutlet weak var followerLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    
    @IBOutlet weak var assetTabView: UITableView!
    
    @IBOutlet weak var assetTitleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get user profile image and username
        userDetails()
        profileImg.image = transferImg
        print("My image retrive",profileImg.image)
        
        profileImg.layer.cornerRadius = 12
        profileImg.clipsToBounds = true
        
        //Follow UI changes
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        
        //Asset UI changes
        assetTitleLbl.layer.cornerRadius = 5
        assetTitleLbl.clipsToBounds = true
        
        
        //Hide tab bar
        tabBarController?.tabBar.isHidden = true
        
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDetail", for: indexPath) as! userDetailTableViewCell
        return cell

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func settingBtnTap(_ sender: Any) {
        print("Setting btn tapped:::::")
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TextScroll") as! TextScroll
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
