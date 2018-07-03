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

    func updateFollowers(position : Int)
    
    func updateUnFollowers(position : Int)
    
}



class peopleTableViewCell: UITableViewCell {
    

    @IBOutlet weak var profileUserImage: UIImageView!
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var userID: String!
    var delegate: PeopleTableViewCellDelegate?
    var followers   : [String : Any]?

    var user: Users? {
        didSet {
            updateView()
        }
    }
    
    var mybool = true

    @IBAction func followBtnTapped(_ sender: Any) {
        
        print("Follow tapped sender.tag: \((sender as AnyObject).tag)")
        let sendertag = (sender as AnyObject).tag
        print("1.followers, user?.id: \(followers, user?.id)")
        
         if let followersList = followers,let uid = user?.id {
            
            print("2.followers, user?.id: \(followers, user?.id)")
            
            if let isFollowing = followersList[uid] as? Bool {
                
            print("3.isFollowing followBtnTapped: \(isFollowing)")
                
            if isFollowing {

                print("4.isFollowing: true")
                users[sendertag!].isFollowing = Bool()

                configureFollowButton()
                return

            }

         }
            
            print("5.followersList[uid] Bool does not exist")
            users[sendertag!].isFollowing = true
            configureUnFollowButton()

            
        } else {
            
            print("6.Else Condition NIL = let followersList = followers,let uid = user?.id")
            users[sendertag!].isFollowing = true
            configureUnFollowButton()
            
        }
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        print("Awake from Nib")
        followBtn.layer.borderWidth = 1
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true

        self.profileUserImage.layer.cornerRadius = self.profileUserImage.frame.size.width / 2;
        self.profileUserImage.clipsToBounds = true
        
    }

    
    @objc func nameLabel_TouchUpInside() {
        print("Following user:::::")
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
        
    }
    
    func configureFollowButton() {
        
        followBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        followBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        followBtn.setTitle("Follow", for: UIControlState.normal)
        followBtn.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
        
    }
    
    func configureUnFollowButton() {
        
        followBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        followBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor.clear
        followBtn.setTitle("Following", for: UIControlState.normal)
        followBtn.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
        
    }
    
    @objc func followAction(sender : UIButton) {
        
        print("followAction")
        
        if let delegatexits = delegate {
            
            delegatexits.updateFollowers(position: sender.tag)
        }
        
    }
    
    @objc func unFollowAction(sender : UIButton) {
        
        print("UnfollowAction")

        if let delegatexits = delegate {
            
            delegatexits.updateUnFollowers(position: sender.tag)
        }
       
    }

    func updateStateFollowButton() {
        if user!.isFollowing! {
            configureUnFollowButton()
        } else {
            configureFollowButton()
            
        }
        
    }
    
   
    
    
}
    


