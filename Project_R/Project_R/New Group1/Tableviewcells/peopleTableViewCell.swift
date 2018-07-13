//
//  peopleTableViewCell.swift
//  Project_R
//
//  Created by CZSM2 on 06/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import SDWebImage
import Nuke

protocol PeopleTableViewCellDelegate {
    func goToProfileUserVC(userId: String)
   
    func updateFollowers(position : Int,cell : peopleTableViewCell)
    
    func updateUnFollowers(position : Int,cell : peopleTableViewCell)
    
}



class peopleTableViewCell: UITableViewCell {
    

    @IBOutlet weak var profileUserImage: UIImageView!
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var userID: String!
    var delegate: PeopleTableViewCellDelegate?
    var followers   : [String : Any]?
    var homeVC: peopleViewController?

    var user: Users! {
        didSet {
            updateView()
        }
    }
    
    var mybool = true

   
    
    override func awakeFromNib() {
        super.awakeFromNib()

        followBtn.layer.borderWidth = 1
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true

        self.profileUserImage.layer.cornerRadius = self.profileUserImage.frame.size.width / 2;
        self.profileUserImage.clipsToBounds = true
        
   
    }

    
    @objc func nameLabel_TouchUpInside() {

        if let id = user?.id {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     

        // Configure the view for the selected state
    }
    
    @objc func handlefollowbtnTap(){
    
//        followers()
    
    }
    

    
    func updateView() {
        
        profileUserName.text = user?.username
        
        if let photoUrlString = user?.profileImageURL {
            
            let photoUrl = URL(string: photoUrlString)
            profileUserImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholder-photo"))
        }
//        if let followersList = followers,let uid = user?.id {
//        if let isFollowing = followersList[uid] as? Bool {
//        if isFollowing {
//            configureUnFollowButton()
//        } else {
//            configureFollowButton()
//        }
//        }
//        }
        
      if let followersList = followers,let uid = user?.id {

            print("2.followers, user?.id: \(followers, user?.id)")
            
            
            if let isFollowing = followersList[uid] as? Bool {

                print("3.isFollowing followBtnTapped: \(isFollowing)")

                if isFollowing {

                    print("4.isFollowing: true")
                    
//                    configureUnFollowButton()
                    updateStateFollowButton()
                    return

                }

            }else {
                
                print("5.followersList[uid] Bool does not exist")
                
//                configureFollowButton()
                updateStateFollowButton()
            }

            
            

        }
        else {

            print("6.Else Condition NIL = let followersList = followers,let uid = user?.id")

//            configureFollowButton()

       updateStateFollowButton()

        }
   
        
        
//        updateStateFollowButton()
        
    }
    
    func configureFollowButton() {
        
        
        followBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        followBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        followBtn.isUserInteractionEnabled = true
        
//        followBtn.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
        
            DispatchQueue.main.async {
                
                self.followBtn.addTarget(self, action: #selector(self.followAction(sender:)), for: .touchUpInside)
                
            }
            
            followBtn.setTitle("Follow", for: UIControlState.normal)

  

    }
    
    func configureUnFollowButton() {
        
        
        followBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        followBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor.clear
      
         followBtn.isUserInteractionEnabled = true
        
//        followBtn.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
        
        DispatchQueue.main.async {
            
            self.followBtn.addTarget(self, action: #selector(self.unFollowAction(sender:)), for: .touchUpInside)
        }
        
          followBtn.setTitle("Following", for: UIControlState.normal)

       
        
    }
    
    @objc func followAction(sender : UIButton) {
        
//            if let delegatexits = delegate {
//
//                delegatexits.updateFollowers(position: (sender as AnyObject).tag, cell: self)
//
//            }
    
        
        if user!.isFollowing! == false {
            
            API.Follow.followAction(withUser: (user?.id)!)
            
            configureUnFollowButton()
            
            user?.isFollowing! = true
        }
        
    }
    
    @objc func unFollowAction(sender : UIButton) {
        
//        if let delegatexits = delegate {
//
//            delegatexits.updateUnFollowers(position: (sender as AnyObject).tag, cell: self)
//        }
       
        if user!.isFollowing! == true {
            
            API.Follow.unFollowAction(withUser: (user?.id!)!)
            
            configureFollowButton()
            
            user?.isFollowing! = false
        }
        
    }

    func updateStateFollowButton() {
        

        if let status = user.isFollowing {
            
            print("status \(status)")
            
            if user.isFollowing! {
                
                configureUnFollowButton()
                
            } else {
                
                configureFollowButton()
                
            }
    }
    }
    
}
    


