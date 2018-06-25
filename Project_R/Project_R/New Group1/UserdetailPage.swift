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
  
    
    var transferImg: UIImage!
    
    var posts: [Post] = []
    var saves = [save]()
    var activities = [activity]()
//    var user: Users!
    
    var user: Users? {
        didSet {
            updateView()
        }
    }


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
    
    @IBOutlet weak var menuBar: CustomSegmentedControl!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        //Get user profile image and username
//        userDetails()
//        profileImg.image = transferImg
//        print("My image retrive",profileImg.image)
        
        
        //Follow UI changes
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        
        //Asset UI changes
//        assetTitleLbl.layer.cornerRadius = 5
//        assetTitleLbl.clipsToBounds = true
      
        
        //Hide tab bar
        tabBarController?.tabBar.isHidden = true
        
        fetchUser()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchUser()
        fetchMyPosts(completion: { status in
            
            DispatchQueue.main.async {
                self.assetTabView.reloadData()
            }
            
            
        })
        fetchMYSaves(completion: { status in
            
            DispatchQueue.main.async {
                self.assetTabView.reloadData()
            }
            
        })
        
        fetchMYActivity(completion:  { status in
            
            
            DispatchQueue.main.async {
                self.assetTabView.reloadData()
            }
            
        })
    }
    
    
    
    func fetchUser() {
        
//        self.activityIndicator.startAnimating()
    
        API.User.observeCurrentUser { user in
            
            
            DispatchQueue.main.async {
                self.user = user

            }
            
        }
    }
    
    func fetchMyPosts(completion: @escaping (String) -> Void) {
        posts.removeAll()
       
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        API.Post.observeUserPosts(withID: currentUser.uid, completion: {
            post in
            self.posts = post
            completion("success")
        })
        
        
    }
    
    func fetchMYSaves(completion: @escaping (String) -> Void) {
        
        saves.removeAll()
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        API.MySaves.observeUserSaves(withID: currentUser.uid, completion: {
            
            savee in
            self.saves = savee
            completion("Success")
            
        })
        
    }
    func fetchUserCount() {
        
        self.assetTabView.reloadData()
    }
    
    func fetchMYActivity(completion: @escaping (String) -> Void) {
        
        activities.removeAll()
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        API.MyActivity.observeUserSaves(withID: currentUser.uid, completion: {
            
            activitee in
            self.activities = activitee
            completion("Success")
            
        })
        
    }
    
//    func userDetails() {
//
//        API.User.observeCurrentUser { (user) in
//
//            if let profileurl = user.profileImageURL{
//
//                self.profileImg.image = nil
//                if profileurl != "" {
//
//                    Manager.shared.loadImage(with: URL(string: profileurl)!, into: self.profileImg)
//                }
//            }
//
//            if self.userName.text != nil {
//                self.userName.text = user.username
//                self.navigationItem.title = "@"  + self.userName.text!
//
//            }
//
//        }
//
//
//    }
    
    func updateView() {
        
        self.userName.text = user?.username
        self.navigationItem.title = "@"  + self.userName.text!
        
        
        if let photoURL = user?.profileImageURL {
            self.profileImg.sd_setImage(with: URL(string: photoURL))
        }
        
        API.Follow.fetchCountFollowing(userId: user!.id!) { (count) in
            
            if self.followingCount.text != nil {
                self.followingCount.text = "\(count)"
                print("followingcountlabel::::\(self.followingCount)")
                
            }
        }
        
        API.Follow.fetchCountFollowers(userId: API.User.CURRENT_USER!.uid) { (count) in
            
            if self.followersCount.text != nil {
                self.followersCount.text = "\(count)"
                print("followersCountLabel::::\(self.followersCount)")
                
            }
        }
        
        API.Post.fetchCountuserPost(withID: API.User.CURRENT_USER!.uid) { (count) in
            
            if self.assetCount.text != nil {
                
                self.assetCount.text = "\(count)"
                print("postcountLabel::::\(self.assetCount)")
            }
        }
        
        profileImg.layer.cornerRadius = 12
        profileImg.clipsToBounds = true
        //        profileImageView.layer.borderWidth = 2
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        var returnValue = 0
        
        switch(menuBar.selectedSegmentIndex)
        {
        case 0:
            
            returnValue = posts.count
            print("Get post count",posts.count)
            break
        case 1:
            returnValue = saves.count
            break
            
        case 2:
            returnValue = activities.count
            break
            
        default:
            break
            
        }
        
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "userDetail", for: indexPath) as! userDetailTableViewCell
        
        switch(menuBar.selectedSegmentIndex)
            
        {
        case 0:
            
            cell.post = posts[indexPath.row]
            
            
            cell.itemName.isHidden = false
            cell.userProduct.isHidden = false
            cell.itemdetail.isHidden = false
            cell.itemVerified.isHidden = false
            
            break
        case 1:
            
            cell.saves = saves[indexPath.row]
            
            
            cell.itemName.isHidden = false
            cell.userProduct.isHidden = false
            cell.itemdetail.isHidden = false
            cell.itemVerified.isHidden = false
            
            break
            
        case 2:
            
           
            cell.itemName.isHidden = true
            cell.userProduct.isHidden = true
            cell.itemdetail.isHidden = true
            cell.itemVerified.isHidden = true
            
            break
            
        default:
            break
            
        }
        
        return cell
    }



    @IBAction func settingBtnTap(_ sender: Any) {
        print("Setting btn tapped:::::")
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TextScroll") as! TextScroll
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        
         navigationController?.popViewController(animated: true)
    }
}
