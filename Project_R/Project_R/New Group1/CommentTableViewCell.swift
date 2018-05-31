//
//  CommentTableViewCell.swift
//  Blocstagram
//
//  Created by ddenis on 1/20/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Nuke

protocol  CommentTableViewCellDelegate {
    
    func updateComments(position : Int)
}

class CommentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    var delegate : CommentTableViewCellDelegate?

    var comment: Comment? {
        didSet {
            updateView()
        }
    }
    
    var user: Users? {
        didSet {
            updateUserInfo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        commentLabel.text = ""
        
        // add a tap gesture to the comment image for users to segue to the commentVC
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteComments(sender:)))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        // add a tap gesture to the like image for users to like a post
        let likeTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteComments2(sender:)))
        nameLabel.addGestureRecognizer(likeTapGesture)
        nameLabel.isUserInteractionEnabled = true
        
        let userImagetap = UITapGestureRecognizer(target: self, action: #selector(deleteComments3(sender:)))
        commentLabel.addGestureRecognizer(userImagetap)
        commentLabel.isUserInteractionEnabled = true
    }

    
    @objc func deleteComments(sender : UITapGestureRecognizer) {
        
        if let delegateexits = delegate {
            
            delegateexits.updateComments(position: (sender.view?.tag)!)
        }
        
    }
    
    @objc func deleteComments2(sender : UITapGestureRecognizer) {
        
        if let delegateexits = delegate {
            
            delegateexits.updateComments(position: (sender.view?.tag)!)
        }
        
    }
    
    @objc func deleteComments3(sender : UITapGestureRecognizer) {
        
        if let delegateexits = delegate {
            
            delegateexits.updateComments(position: (sender.view?.tag)!)
        }
        
    }
    
    
    func updateView() {
        
        commentLabel.text = comment?.commentText
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        if currentUser.uid == comment?.uid {
            
            nameLabel.text = PrefsManager.sharedinstance.username
            profileImageView.image = nil
            Manager.shared.loadImage(with:  URL(string: PrefsManager.sharedinstance.imageURL)!, into: self.profileImageView)
           
            
        } else {
            
            nameLabel.text = comment?.userName
            profileImageView.image = nil
            if let photoURL = comment?.profileImageURL {
               
                Manager.shared.loadImage(with:  URL(string: photoURL)!, into: self.profileImageView)
            }
        }
     
    }
    
    func updateUserInfo() {
        nameLabel.text = user?.username
        if let photoURL = user?.profileImageURL {
            profileImageView.sd_setImage(with: URL(string: photoURL), placeholderImage: UIImage(named: "profile"))
        }
    }
    
    // flush the user profile image before a reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "profile")
    }

}
