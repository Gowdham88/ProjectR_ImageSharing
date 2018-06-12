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
    func updateFollowButton(forUser user: Users)
}



class peopleTableViewCell: UITableViewCell {
    

    @IBOutlet weak var profileUserImage: UIImageView!
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var userID: String!
    var delegate: PeopleTableViewCellDelegate?

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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        profileUserName.addGestureRecognizer(tapGesture)
        profileUserName.isUserInteractionEnabled = true
        
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
        
        if user!.isFollowing! {
            configureUnFollowButton()
        } else {
            configureFollowButton()
        }
        
//        updateStateFollowButton()
    }
    
    func configureFollowButton() {
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true
        
        followBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor(red: 7/255, green: 192/255, blue: 141/255, alpha: 1)
        followBtn.setTitle("Follow", for: UIControlState.normal)
        followBtn.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    
    func configureUnFollowButton() {
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 7/255, green: 192/255, blue: 141/255, alpha: 1).cgColor
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true
        
        followBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor.clear
        followBtn.setTitle("Following", for: UIControlState.normal)
        followBtn.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
    }
    
    @objc func followAction() {
        if user!.isFollowing! == false {
            API.Follow.followAction(withUser: user!.id!)
            configureUnFollowButton()
            user!.isFollowing! = true
//            delegate?.updateFollowButton(forUser: user!)
        }
    }
    
    @objc func unFollowAction() {
        if user!.isFollowing! == true {
            API.Follow.unFollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing! = false
//            delegate?.updateFollowButton(forUser: user!)
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
    


