//
//  FeedApi.swift
//  InstagramClone
//
//  Created by The Zero2Launch Team on 2/1/17.
//  Copyright © 2017 The Zero2Launch Team. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
class FeedApi {
    var REF_FEED = Database.database().reference().child("feed")
    let db = Firestore.firestore()
    
    func observeFeed(withId id: String, completion: @escaping (Post) -> Void) {
      
           db.collection("feed")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        
                        if diff.document.documentID == id {
                            
                            print("New city: \(diff.document.data())")
                            let key = diff.document.documentID
                            API.Post.observePost(withID: key, completion: { (post) in
                                completion(post)
                            })
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
    
    func observeFeedRemoved(withId id: String, completion: @escaping (Post) -> Void) {
        
        db.collection("feed")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        
                    }
                    if (diff.type == .modified) {
                        print("Modified city: \(diff.document.data())")
                    }
                    if (diff.type == .removed) {
                        print("Removed city: \(diff.document.data())")
                        
                        if diff.document.documentID == id {
                            
                            print("New city: \(diff.document.data())")
                            let key = diff.document.documentID
                            API.Post.observePost(withID: key, completion: { (post) in
                                completion(post)
                            })
                        }
                    }
                }
        }
        
    }
}
