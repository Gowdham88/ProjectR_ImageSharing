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
    func goToProfileUserVC(userId: String, followingStatus: Bool)


//    func updateFollowers(position : Int,cell : peopleTableViewCell)
//    
//    func updateUnFollowers(position : Int,cell : peopleTableViewCell)

    
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
        
        print("Get username <detail>::::",user)
        
        followBtn.layer.borderWidth = 1
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true

        self.profileUserImage.layer.cornerRadius = self.profileUserImage.frame.size.width / 2;
        self.profileUserImage.clipsToBounds = true
        

//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
//        profileUserName.addGestureRecognizer(tapGesture)
//        profileUserName.isUserInteractionEnabled = true
        
    }

    
//    @objc func nameLabel_TouchUpInside() {
//
//        if let id = user?.id {
//            let status = user.isFollowing
//            print("Get the following status===\(status)")
//            delegate?.goToProfileUserVC(userId: id, followingStatus: status!)
//        }
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     

        // Configure the view for the selected state
    }
    
    @objc func handlefollowbtnTap(){
    
//        followers()
    
    }
    

    
    func updateView() {
        
        print("updateView")
        
        profileUserName.text = user?.username
        
        if let photoUrlString = user?.profileImageURL {
            
            let photoUrl = URL(string: photoUrlString)
            profileUserImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholder-photo"))
        }
        print("user.isFollowing: \(user.isFollowing)")
        print("userID: \(user.id)")
        
        if user.isFollowing! {
            
            configureUnFollowButton()
            
        } else {
            
            configureFollowButton()
            
        }
        
//        updateStateFollowButton()
        
    }
    
    func configureFollowButton() {
        
        followBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        followBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        followBtn.isUserInteractionEnabled = true
        
//        followBtn.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
        
        followBtn.setTitle("Follow", for: UIControlState.normal)

                self.followBtn.addTarget(self, action: #selector(self.followAction(sender:)), for: .touchUpInside)
                
    }
    
    func configureUnFollowButton() {
        
        
        followBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        followBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor.clear
      
         followBtn.isUserInteractionEnabled = true
        
//        followBtn.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
        
//        DispatchQueue.main.async {
        
        followBtn.setTitle("Following", for: UIControlState.normal)

            self.followBtn.addTarget(self, action: #selector(self.unFollowAction(sender:)), for: .touchUpInside)
//        }
        

       
        
    }
    
    @objc func followAction(sender : UIButton) {
        
        if user!.isFollowing! == false {
            
            API.Follow.followAction(withUser: (user?.id)!)
            
            configureUnFollowButton()
            
            user?.isFollowing! = true
        }
        
    }
    
    @objc func unFollowAction(sender : UIButton) {
        
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
    


