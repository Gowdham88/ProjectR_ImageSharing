//
//  checkInPost.swift
//  Project_R
//
//  Created by CZSM2 on 05/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import Foundation
import FirebaseAuth

class checkInPost {
    var caption: String?
    var photoURL: String?
    var uid: String?
    var id: String?
    var likeCount: Int?
    var likes: Dictionary<String, Bool>?
    var isLiked: Bool?
    var userName : String?
    var profileImageURL : String?
    var postTime : Double?
    var documentID: String?
    var rating: String?
    var location: String?
    var lat: String?
    var long: String?
}

extension checkInPost {
    
    
    
    static func transformPost(postDictionary: [String: Any], key: String) -> checkInPost {
        let checkinpost = checkInPost()
        
        checkinpost.id = key
        checkinpost.caption = postDictionary["caption"] as? String
        checkinpost.photoURL = postDictionary["photoURL"] as? String
        checkinpost.uid = postDictionary["uid"] as? String
        checkinpost.likeCount = postDictionary["likeCount"] as? Int
        checkinpost.likes = postDictionary["likes"] as? Dictionary<String, Bool>
        checkinpost.userName = postDictionary["userName"] as? String
        checkinpost.profileImageURL = postDictionary["profileImageURL"] as? String
        checkinpost.postTime        = postDictionary["postTime"] as? Double
        checkinpost.documentID = postDictionary["documentID"] as? String
        checkinpost.rating = postDictionary["rating"] as? String
        checkinpost.location = postDictionary["location"] as? String
        checkinpost.lat = postDictionary["lat"] as? String
        checkinpost.long = postDictionary["long"] as? String
        
        if let currentUserID = Auth.auth().currentUser?.uid {
            if checkinpost.likes != nil {
                checkinpost.isLiked = checkinpost.likes![currentUserID]

            }
        }
        
        return checkinpost
    }
    
}
