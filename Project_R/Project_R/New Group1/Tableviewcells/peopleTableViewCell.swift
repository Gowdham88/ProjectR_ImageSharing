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
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlefollowbtnTap))
//        followBtn.addGestureRecognizer(tapGesture)
//        followBtn.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
//        profileUserName.addGestureRecognizer(tapGesture)
//        profileUserName.isUserInteractionEnabled = true
        
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
        
        if let followersList = followers,let uid = user?.id {
            
            if let isFollowing = followersList[uid] as? Bool {
                
                if isFollowing {
                    
                    configureUnFollowButton()
                    
                    
                }
                
                else
                {
                    configureFollowButton()
                    
                }
                
            } else {
                
                configureFollowButton()
            }
           
        } else {
        
           configureFollowButton()
            
        }
        
      
    }
    
    func configureFollowButton() {
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true
        
        followBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        followBtn.setTitle("Follow", for: UIControlState.normal)
        followBtn.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    
    func configureUnFollowButton() {
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true
        
        followBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor.clear
        followBtn.setTitle("Following", for: UIControlState.normal)
        followBtn.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
    }
    
    @objc func followAction(sender : UIButton) {
        print("Follow button tapped")
        
        
        
        if let delegatexits = delegate {
            
            delegatexits.updateFollowers(position: sender.tag)
        }
        
        
    }
    
    @objc func unFollowAction(sender : UIButton) {
        
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
    


