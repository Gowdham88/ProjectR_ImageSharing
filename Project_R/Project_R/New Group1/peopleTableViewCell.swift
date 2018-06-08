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
    }
    
    func configureFollowButton() {
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true
        
        followBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        followBtn.setTitle("Follow", for: UIControlState.normal)
        followBtn.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    
    func configureUnFollowButton() {
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
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
        }
    }
    
    @objc func unFollowAction() {
        if user!.isFollowing! == true {
            API.Follow.unFollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing! = false
        }
    }
        

    
        func updatefollowingbtn() {
           DispatchQueue.main.async {
       
//            let followBnt = post.isLiked ?? false ? "likeSelected" : "like"

            
            }
            
    }
    
    //    let uid = FIRAuth.auth()!.currentUser!.uid
    //    let ref = FIRDatabase.database().reference()
    //    let key = ref.child("users").childByAutoId().key
    //
    //    var isFollower = false
    //
    //    ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
    //
    //    if let following = snapshot.value as? [String : AnyObject] {
    //    for (ke, value) in following {
    //    if value as! String == self.user[indexPath.row].userID {
    //    isFollower = true
    //
    //    ref.child("users").child(uid).child("following/\(ke)").removeValue()
    //    ref.child("users").child(self.user[indexPath.row].userID).child("followers/\(ke)").removeValue()
    //
    //    self.tableview.cellForRow(at: indexPath)?.accessoryType = .none
    //    }
    //    }
    //    }
    //    if !isFollower {
    //    let following = ["following/\(key)" : self.user[indexPath.row].userID]
    //    let followers = ["followers/\(key)" : uid]
    //
    //    ref.child("users").child(uid).updateChildValues(following)
    //    ref.child("users").child(self.user[indexPath.row].userID).updateChildValues(followers)
    //
    //    self.tableview.cellForRow(at: indexPath)?.accessoryType = .checkmark
    //    }
    //    })
    //    ref.removeAllObservers()

}
