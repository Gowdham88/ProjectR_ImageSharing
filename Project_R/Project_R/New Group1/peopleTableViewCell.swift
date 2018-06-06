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


class peopleTableViewCell: UITableViewCell {
    

    @IBOutlet weak var profileUserImage: UIImageView!
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var userID: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlefollowbtnTap))
        followBtn.addGestureRecognizer(tapGesture)
        followBtn.isUserInteractionEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func handlefollowbtnTap(){
    
        followers()
    
    }
    
    func followers() {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        print("currentuid:::::\(currentUserID)")
        
        
//            let key = db.collection("users").document().value(forKey: "key")
            var isFollower = false
            var users : Users!
        
        API.User.observeCurrentUser { user in
            users = user
            let db = Firestore.firestore()
            db.collection("followers").document(currentUserID).setData([
                currentUserID: "true",
                
                ]){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
//                        ProgressHUD.showError("Photo Save Error: \(err.localizedDescription)")
                        return
                    } else {
                        
                        print("Document successfully written!")
                        
                        db.collection("following").document(currentUserID).setData([
                            currentUserID: "true",
                            
                            ]){ err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                    ProgressHUD.showError("Photo Save Error: \(err.localizedDescription)")
                                    return
                                }
                        }
                    }
            }
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
