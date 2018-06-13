//
//  saveApi.swift
//  Project_R
//
//  Created by CZSM2 on 13/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import Foundation
//
//  PostAPI.swift
//  Blocstagram
//
//  Created by ddenis on 1/24/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import Foundation
import Firebase

//var postCount: Int?

class saveApi {
    
    var REF_POSTS = Database.database().reference().child("save")
    var globalhandlerpost : DatabaseHandle!
    var listner : ListenerRegistration?
    let db = Firestore.firestore()
    var saveList = [save]()
    var sortpostList = [SortPost]()
    var sortSaveList = [sortSave]()
    
    
    func observeSavePosts(completion: @escaping ([save],DocumentSnapshot?) -> Void) {
        
        db.collection("posts").order(by: "savePostTime", descending: true).limit(to: 5)
            .getDocuments() { (querySnapshot, err) in
                
                
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(self.saveList,nil)
                } else {
                    
                    self.saveList.removeAll()
                    
                    for document in querySnapshot!.documents {
                        
                        let newSave = save.transformSave(saveDictionary: document.data(), key: document.documentID)
                        self.saveList.append(newSave)
                    }
                    
                    let lastSnapshot = querySnapshot?.documents.last
                    
                    completion(self.saveList,lastSnapshot)
                    
                }
                
                
        }
    }
    
    func observePostsPage(lastSnapshot : DocumentSnapshot,completion: @escaping ([save],DocumentSnapshot?) -> Void) {
        
        db.collection("save").order(by: "savePostTime", descending: true).start(afterDocument: lastSnapshot).limit(to: 5)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(self.saveList,nil)
                } else {
                    
                    self.saveList.removeAll()
                    
                    for document in querySnapshot!.documents {
                        let newSave = save.transformSave(saveDictionary: document.data(), key: document.documentID)
                        
                        self.saveList.append(newSave)
                    }
                    
                    let lastSnapshot = querySnapshot?.documents.last
                    
                    print(lastSnapshot ?? "nlk")
                    print(self.saveList.count)
                    
                    completion(self.saveList,lastSnapshot)
                    
                }
        }
    }
    
    
    
    
    func observeUserSaves(withID id:String,completion: @escaping ([save]) -> Void) {
        db.collection("save").whereField("uid", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                //                let count  = querySnapshot?.count
                //                postCount = count
                //                print("postCounts:::::=\(String(describing: postCount))")
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    self.saveList.removeAll()
                    self.sortSaveList.removeAll()
                    
                    for document in querySnapshot!.documents {
                        
                        let newsave = save.transformSave(saveDictionary: document.data(), key: document.documentID)
                        
                        self.sortSaveList.append(sortSave(SortingPostSaveList: newsave, timestamp: 0))
                        
                        
                    }
                    
                    let postPrimaryList = self.sortSaveList.sorted {
                        $0.timestamp > $1.timestamp
                    }
                    
                    for item in postPrimaryList {
                        
                        self.saveList.append(item.SortingPostSaveList)
                    }
                    
                    
                    completion(self.saveList)
                }
        }
    }
    
    
  
    
    
    func observeSave(withID id:String, completion: @escaping (save) -> Void) {
        let docRef = db.collection("save").document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                
                let newsave = save.transformSave(saveDictionary: document.data()!, key: document.documentID)
                
//                let post = Post.transformPost(postDictionary: document.data()!, key:document.documentID)
                completion(newsave)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func Recuringpoststop() {
        
        if let handle = self.listner {
            
            handle.remove()
        }
        
        
        
    }
    
}
