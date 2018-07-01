//
//  CommentTableViewCell.swift
//  Blocstagram
//
//  Created by ddenis on 1/20/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import Nuke

protocol  CommentTableViewCellDelegate {
    
    func updateComments(position : Int)
}

class CommentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    var delegate : CommentTableViewCellDelegate?
    var userss = [Users]()
    var currentuser = [UserAPI]()
    var posts: [Post] = []

    var currentName: String! = ""
    var postUSerName: String! = ""
    var  postUserUID: String! = ""
    
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
      
        API.User.observeCurrentUser(completion: { (user) in
            if self.currentName != nil {
                
                self.currentName = user.username!
                
                print("currentname::\(String(describing: self.currentName))")
                
            }
        })
      
        
        
     
        commentLabel.text = comment?.commentText
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let db = Firestore.firestore()
        let docRef = db.collection("posts").whereField("documentID", isEqualTo: comment?.postid).limit(to: 500)
        
        docRef.getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let postget = API.Post.observePost(withID: document.documentID, completion: { (post) in
                        
                        self.postUSerName = post.userName
                        print("posusername:::\(self.postUSerName)")
                        self.postUserUID = post.uid
                    })
                    
                }
            }
        
        }
        
        if currentUser.uid == comment?.uid {
            
            nameLabel.text = PrefsManager.sharedinstance.username
            profileImageView.image = nil
            Manager.shared.loadImage(with:  URL(string: PrefsManager.sharedinstance.imageURL)!, into: self.profileImageView)
            
            let db = Firestore.firestore()
         
            
            if self.postUSerName != nil {
              
                
                print("postUSerName::\(String(describing: self.postUSerName))")
            }
                   
                    self.currentName = self.comment?.userName
            print("currentusernamesss:::\(self.currentName)")
            let finalcomment = self.currentName + " " + "commented on" + " " + self.postUSerName
            print("finalcomment::::\(finalcomment)")
            
            db.collection("activity").document().setData([
                "uid": self.postUserUID ?? "empty",
                "currentUserUID": API.User.CURRENT_USER?.uid ?? "empty",
                "currentUserName": self.currentName ?? "empty",
                "activityName": finalcomment + " " + "product." ,
                "userName"  : self.postUSerName ?? "empty"
                
            ]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                    ProgressHUD.showError("Error : \(err.localizedDescription)")
                } else {
                    
                    print("Document successfully committed!")
                }
            }
        
            
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
