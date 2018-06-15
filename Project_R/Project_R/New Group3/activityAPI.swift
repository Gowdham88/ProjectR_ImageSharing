//
//  activityAPI.swift
//  Project_R
//
//  Created by CZSM2 on 15/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import Foundation

import Foundation
import Firebase

//var postCount: Int?

class activityApi {
    
    var REF_POSTS = Database.database().reference().child("activity")
    var globalhandlerpost : DatabaseHandle!
    var listner : ListenerRegistration?
    let db = Firestore.firestore()
    var activityList = [activity]()
//    var sortpostList = [SortPost]()
    var sortactivityList = [sortActivity]()
    
    
//    func observeSavePosts(completion: @escaping ([save],DocumentSnapshot?) -> Void) {
//
//        db.collection("save").order(by: "savePostTime", descending: true).limit(to: 5)
//            .getDocuments() { (querySnapshot, err) in
//
//
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                    completion(self.saveList,nil)
//                } else {
//
//                    self.saveList.removeAll()
//
//                    for document in querySnapshot!.documents {
//
//                        let newSave = save.transformSave(saveDictionary: document.data(), key: document.documentID)
//                        self.saveList.append(newSave)
//                    }
//
//                    let lastSnapshot = querySnapshot?.documents.last
//
//                    completion(self.saveList,lastSnapshot)
//
//                }
//
//
//        }
//    }
//
//    func observeSavePage(lastSnapshot : DocumentSnapshot,completion: @escaping ([save],DocumentSnapshot?) -> Void) {
//
//        db.collection("save").order(by: "savePostTime", descending: true).start(afterDocument: lastSnapshot).limit(to: 5)
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                    completion(self.saveList,nil)
//                } else {
//
//                    self.saveList.removeAll()
//
//                    for document in querySnapshot!.documents {
//                        let newSave = save.transformSave(saveDictionary: document.data(), key: document.documentID)
//
//                        self.saveList.append(newSave)
//                    }
//
//                    let lastSnapshot = querySnapshot?.documents.last
//
//                    print(lastSnapshot ?? "nlk")
//                    print(self.saveList.count)
//
//                    completion(self.saveList,lastSnapshot)
//
//                }
//        }
//    }
//
    
    
    
    func observeUserSaves(withID id:String,completion: @escaping ([activity]) -> Void) {
        db.collection("activity").whereField("currentUserUID", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                //                let count  = querySnapshot?.count
                //                postCount = count
                //                print("postCounts:::::=\(String(describing: postCount))")
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
//                    var activityList = [activity]()
//                    var sortactivityList = [sortActivity]()
                    
                    self.activityList.removeAll()
                    self.sortactivityList.removeAll()
                    
                    for document in querySnapshot!.documents {
                        
                        let newactivity = activity.transformActivity(activityDictionary: document.data(), key: document.documentID)
                        self.sortactivityList.append(sortActivity(SortingActivityList: newactivity, timestamp: 0))
    
                    }
                    
                    let postPrimaryList = self.sortactivityList.sorted {
                        $0.timestamp > $1.timestamp
                    }
                    
                    for item in postPrimaryList {
                        
                        self.activityList.append(item.SortingActivityList)
                    }
                    
                    
                    completion(self.activityList)
                }
        }
    }
    
    
    
    
//
//    func observeSave(withID id:String, completion: @escaping (save) -> Void) {
//        let docRef = db.collection("save").document(id)
//
//        docRef.getDocument { (document, error) in
//            if let document = document {
//
//                let newsave = save.transformSave(saveDictionary: document.data()!, key: document.documentID)
//
//                //                let post = Post.transformPost(postDictionary: document.data()!, key:document.documentID)
//                completion(newsave)
//            } else {
//                print("Document does not exist")
//            }
//        }
//    }
//
    func Recuringpoststop() {
        
        if let handle = self.listner {
            
            handle.remove()
        }
        
        
        
    }
    
}
