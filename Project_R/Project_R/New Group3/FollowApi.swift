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
                print("FollowAction following ref API id:true")
                
                return
            }
            
            // For next time
            print("FollowAction following ref API NO snapshot id:true")

            var data = _snapshot.data()
            data![id] = true
            followingRef.setData(data!)
           
        }
        
        let followersRef = Firestore.firestore().collection("followers").document(id)
        
        followersRef.getDocument { (snapshot, error) in
            guard let _snapshot = snapshot else {return}
            
            if !_snapshot.exists {
                /// First time following someone
                print("FollowAction followersref API id:true")
 followersRef.setData([API.User.CURRENT_USER!.uid: true])
                self.stopAnimating()
                
                return
            }
            
            // For next time
            print("FollowAction followersref API id:true")
            
            var data = _snapshot.data()
            data![API.User.CURRENT_USER!.uid] = true
            followersRef.setData(data!)
            self.stopAnimating()
            
        }

        
    }
    
    func unFollowAction(withUser id: String) {

        startAnimating()
        
//        let docRef = db.collection("user-posts").document(id)
        
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//                self.db.collection("feed").document(API.User.CURRENT_USER!.uid).setData([document.documentID: NSNull()])
//                self.db.collection("feed").document(API.User.CURRENT_USER!.uid).delete()
//
//            } else {
//
//                print("feed Document does not exist")
//
//            }
//
//        }

        db.collection("followers").document(id).updateData([
            API.User.CURRENT_USER!.uid: FieldValue.delete(),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Unfollow followers Document field successfully deleted")
                }
        }
        db.collection("following").document(API.User.CURRENT_USER!.uid).updateData([
            id: FieldValue.delete(),
            ])
        { err in
                if let err = err {

                    print("Error updating document: \(err)")

                } else {

                    print("Unfollow following Document field successfully deleted")

                }

        }
//
//        db.collection("followers").document(id).delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
        
//        db.collection("following").document(API.User.CURRENT_USER!.uid).delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }

        
        stopAnimating()

    }
    
    func startAnimating() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
    }
    func stopAnimating() {
        
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        
    }
    
    func isFollowing(userId: String, completed: @escaping(Bool) -> Void) {
        db.collection("following").document((API.User.CURRENT_USER?.uid)!)
            .addSnapshotListener { documentSnapshot, error in

                if let mysnapshotdata = documentSnapshot?.data()
                
                {
                    
                    completed(true)
                    
                } else {
                    
                    completed(false)
                    
                }
                
//                if mysnapshotdata![userId] == nil {
//
//                    print("Completed == False")
//
//
//
//                } else {
//
//                    print("Completed == True")
//
//
//
//                }
                
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                print("Current data: \(document.data())")
        }

    
    
//    func isFollowing(userId: String, completed: @escaping(Bool) -> Void) {
//
//        db.collection("following").document((API.User.CURRENT_USER?.uid)!).getDocument(completion: {(snapshot, error) in
//
//            var mysnapshotdata = documentSnapshot?.data()
//
//            print("snapshot?.exists: \(mysnapshotdata![userId])")
//
//
//            if mysnapshotdata![userId] == nil {
//
//                print("Completed == False")
//
//                completed(false)
//
//            } else {
//
//                print("Completed == True")
//
//                completed(true)
//
//            }
//
//
//        })
    
        /*        followersRef.getDocument { (snapshot, error) in
        
        
        if !_snapshot.exists {
            /// First time following someone
            print("FollowAction followersref API id:true")
            followersRef.setData([API.User.CURRENT_USER!.uid: true])
            self.stopAnimating()
            
            return
        }
        
        // For next time
        print("FollowAction followersref API id:true")
        
        var data = _snapshot.data()
        data![API.User.CURRENT_USER!.uid] = true
        followersRef.setData(data!)
        self.stopAnimating()
        
    }*/
    
            
        
        
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
////                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
////                print("Document data: \(dataDescription)")
//
//                completed( true)
//
//            } else {
//
//                completed( false)
//            }
//        }
 
        //        REF_FOLLOWERS.child(userId).child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
        //            snapshot in
        //            if let _ = snapshot.value as? NSNull {
        //                completed(false)
        //            } else {
        //                completed(true)
        //            }
        //        })
    }
    
    
//    func isFollowingTemp(userId: String, completed: @escaping([String:Any]) -> Void) {
//
//
//
//
//
//        let docRef = db.collection("followers").document(userId)
//
//                docRef.getDocument { (document, error) in
//                    if let document = document, document.exists {
//                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                        print("Document data: \(dataDescription)")
//
//                        completed(document.data()!)
//
//                    } else {
//
//                        completed([:])
//                    }
//                }
//    }
    
    
    
    func fetchCountFollowers(userId: String, completion: @escaping (Int) -> Void) {
        
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
