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

class PostAPI {
    
    var REF_POSTS = Database.database().reference().child("posts")
    var globalhandlerpost : DatabaseHandle!
    var listner : ListenerRegistration?
    let db = Firestore.firestore()
    var postList = [Post]()
    var sortpostList = [SortPost]()
    

    func observePosts(completion: @escaping ([Post],DocumentSnapshot?) -> Void) {
        
        db.collection("posts").order(by: "postTime", descending: true).limit(to: 5)
            .getDocuments() { (querySnapshot, err) in
                
                
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(self.postList,nil)
                } else {
                    
                    self.postList.removeAll()
                    
                    for document in querySnapshot!.documents {
                        
                        let newPost = Post.transformPost(postDictionary: document.data(), key: document.documentID)
                        self.postList.append(newPost)
                    }
                    
                    let lastSnapshot = querySnapshot?.documents.last
                    
                    completion(self.postList,lastSnapshot)
                    
                }
                
                
        }
    }
    
    func observePostsPage(lastSnapshot : DocumentSnapshot,completion: @escaping ([Post],DocumentSnapshot?) -> Void) {
        
        db.collection("posts").order(by: "postTime", descending: true).start(afterDocument: lastSnapshot).limit(to: 5)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(self.postList,nil)
                } else {
                    
                    self.postList.removeAll()
                    
                    for document in querySnapshot!.documents {
                        
                        let newPost = Post.transformPost(postDictionary: document.data(), key: document.documentID)
                        self.postList.append(newPost)
                    }
                    
                    let lastSnapshot = querySnapshot?.documents.last
                    
                    print(lastSnapshot ?? "nlk")
                    print(self.postList.count)
                    
                    completion(self.postList,lastSnapshot)
                    
                }
        }
    }
    
    
    
    
    func observeUserPosts(withID id:String,completion: @escaping ([Post]) -> Void) {
        db.collection("posts").whereField("uid", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
//                let count  = querySnapshot?.count
//                postCount = count
//                print("postCounts:::::=\(String(describing: postCount))")
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    self.postList.removeAll()
                    self.sortpostList.removeAll()
                    
                    for document in querySnapshot!.documents {
                        
                        let newPost = Post.transformPost(postDictionary: document.data(), key: document.documentID)
                        self.sortpostList.append(SortPost(SortingPostList: newPost, timestamp: newPost.postTime ?? 0))
                    }
                    
                    let postPrimaryList = self.sortpostList.sorted {
                        $0.timestamp > $1.timestamp
                    }
                    
                    for item in postPrimaryList {
                        
                        self.postList.append(item.SortingPostList)
                    }
                  
                    
                    completion(self.postList)
                }
        }
    }
    
    
    func fetchCountuserPost(withID id: String, completion: @escaping (Int) -> Void) {
        
        
        db.collection("posts").whereField("uid", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
            
            let count = querySnapshot?.count
            if count != nil {
                
                print("postnewCount::::\(String(describing: count))")
                completion(count!)
                
            }
        }
        
    }
    
    
    func observePost(withID id:String, completion: @escaping (Post) -> Void) {
        let docRef = db.collection("posts").document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                
                let post = Post.transformPost(postDictionary: document.data()!, key:document.documentID)
                completion(post)
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
