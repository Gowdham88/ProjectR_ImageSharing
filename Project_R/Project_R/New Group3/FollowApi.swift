//
//  FollowApi.swift
//  InstagramClone
//
//  Created by The Zero2Launch Team on 1/30/17.
//  Copyright © 2017 The Zero2Launch Team. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore

class FollowApi {
    
    var activityIndicator = UIActivityIndicatorView()
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    let db = Firestore.firestore()
    
    func followAction(withUser id: String) {
        
        startAnimating()
        
        print("withuser:::\(id)")
        let docRef = db.collection("user-posts").document(id)
        print("id::::\(docRef)")
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//

//
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//
//                self.db.collection("feed").document(API.User.CURRENT_USER!.uid).setData([document.documentID: true])
//
//            } else {
//                print("Document does not exist")

//            }
//        }
//
//
//        self.db.collection("followers").document(id).setData([API.User.CURRENT_USER!.uid: true])
//        self.db.collection("following").document(API.User.CURRENT_USER!.uid).setData([id: true])
//
////        self.db.collection("following").document(API.User.CURRENT_USER!.uid).setData([id: true])
////        REF_FOLLOWERS.child(id).child(API.User.CURRENT_USER!.uid).setValue(true)
////        REF_FOLLOWING.child(API.User.CURRENT_USER!.uid).child(id).setValue(true)
        
        
        let followingRef = Firestore.firestore().collection("following").document(API.User.CURRENT_USER!.uid)
        followingRef.getDocument { (snapshot, error) in
            guard let _snapshot = snapshot else {return}
            
            if !_snapshot.exists {
                /// First time following someone
                followingRef.setData([id: true])
                
                
                return
            }
            
            // For next time
            var data = _snapshot.data()
            data![id] = true
            followingRef.setData(data!)
           
        }
        
        let followersRef = Firestore.firestore().collection("followers").document(id)
        followersRef.getDocument { (snapshot, error) in
            guard let _snapshot = snapshot else {return}
            
            if !_snapshot.exists {
                /// First time following someone
                followersRef.setData([API.User.CURRENT_USER!.uid: true])
                self.stopAnimating()
                
                return
            }
            
            // For next time
            var data = _snapshot.data()
            data![API.User.CURRENT_USER!.uid] = true
            followersRef.setData(data!)
            self.stopAnimating()
            
        }

        
    }
    
    func unFollowAction(withUser id: String) {
        
        startAnimating()
        
        let docRef = db.collection("user-posts").document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.db.collection("feed").document(API.User.CURRENT_USER!.uid).setData([document.documentID: NSNull()])
                self.db.collection("feed").document(API.User.CURRENT_USER!.uid).delete()

            } else {
                
                print("Document does not exist")
                
            }
            
        }
        self.db.collection("followers").document(id).setData([API.User.CURRENT_USER!.uid: NSNull()])
        self.db.collection("following").document(API.User.CURRENT_USER!.uid).setData([id: NSNull()])
        
        stopAnimating()
        
//        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: {
//            snapshot in
//            if let dict = snapshot.value as? [String: Any] {
//                for key in dict.keys {
//                    FIRDatabase.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(key).removeValue()
//                }
//            }
//        })
//
//        REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
//        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    func startAnimating() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
    }
    func stopAnimating() {
        
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        
    }
    
    func isFollowing(userId: String, completed: @escaping ([String : Any]?) -> Void) {
        
        let docRef = db.collection("following").document(userId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                completed(document.data())
                
            } else {
               
                completed(nil)
            }
        }
        
//        REF_FOLLOWERS.child(userId).child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
//            snapshot in
//            if let _ = snapshot.value as? NSNull {
//                completed(false)
//            } else {
//                completed(true)
//            }
//        })
    }
    
//    func fetchCountFollowing(userId: String, completion: @escaping (Int) -> Void) {
//        REF_FOLLOWING.child(userId).observe(.value, with: {
//            snapshot in
//            let count = Int(snapshot.childrenCount)
//            completion(count)
//        })
//
//    }
//
    func fetchCountFollowers(userId: String, completion: @escaping (Int) -> Void) {
//        REF_FOLLOWERS.child(userId).observe(.value, with: {
//            snapshot in
//            let count = Int(snapshot.childrenCount)
//            completion(count)
//        })
        
        
//        let docRef = db.collection("followers").whereField(API.User.CURRENT_USER!.uid, isEqualTo: true)
//
//        docRef.getDocuments() { (querySnapshot, err) in
//            let count = querySnapshot?.count
//            print("followersCount::::\(String(describing: count))")
//        }
        
        db.collection("followers").document(userId).addSnapshotListener { (documentSnapshot, error) in
            let count = documentSnapshot?.data()?.count
            
            if count != nil {
            
            print("followersCount::::\(String(describing: count))")
            completion(count!)
                
            }
        }

    }
    
    
    
        func fetchCountFollowing(userId: String, completion: @escaping (Int) -> Void) {

            
            db.collection("following").document(API.User.CURRENT_USER!.uid).addSnapshotListener { (documentSnapshot, error) in
                
                let count = documentSnapshot?.data()?.count
                if count != nil {
                    
                print("followingCount::::\(String(describing: count))")
                completion(count!)
                    
                }
            }

        }

}//followAPI
