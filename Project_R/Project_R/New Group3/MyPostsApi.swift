//
//  MyPostsApi.swift
//  InstagramClone
//
//  Created by The Zero2Launch Team on 1/15/17.
//  Copyright © 2017 The Zero2Launch Team. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
class MyPostsApi {
    var REF_MYPOSTS = Database.database().reference().child("myPosts")
//    var REF_FEED = Database.database().reference().child("feed")
    let db = Firestore.firestore()
    
    func fetchMyPosts(userId: String, completion: @escaping (String) -> Void) {
        REF_MYPOSTS.child(userId).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
        
        db.collection("myPosts")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        
                        if diff.document.documentID == userId {
                            
                            print("New city: \(diff.document.data())")
                            let key = diff.document.documentID
                            completion(key)
                        }
                        
                    }
                    if (diff.type == .modified) {
                        print("Modified city: \(diff.document.data())")
                    }
                    if (diff.type == .removed) {
                        print("Removed city: \(diff.document.data())")
                    }
                }
        }
        
    }
    
//    func fetchCountMyPosts(userId: String, completion: @escaping (Int) -> Void) {
//        REF_MYPOSTS.child(userId).observe(.value, with: {
//            snapshot in
//            let count = Int(snapshot.childrenCount)
//            completion(count)
//        })
//
//        db.collection("cities").document("SF")
//            .addSnapshotListener { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("Error fetching document: \(error!)")
//                    return
//                }
//                let count = Int(document)
//                completion(count)
//                print("Current data: \(document.data())")
//        }
//
//
//    }
}
