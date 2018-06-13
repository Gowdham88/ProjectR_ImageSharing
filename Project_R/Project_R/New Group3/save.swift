//
//  save.swift
//  Project_R
//
//  Created by CZSM2 on 12/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import Foundation
import FirebaseAuth


class save {
    
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
    var savePostTime: String?
    
    
}

extension save {
    
     static func transformSave(saveDictionary: [String: Any], key: String) -> save {
    
        let Save = save()
        
        Save.id = key
        Save.caption = saveDictionary["caption"] as? String
        Save.photoURL = saveDictionary["photoURL"] as? String
        Save.uid = saveDictionary["uid"] as? String
        Save.likeCount = saveDictionary["likeCount"] as? Int
        Save.likes = saveDictionary["likes"] as? Dictionary<String, Bool>
        Save.userName = saveDictionary["userName"] as? String
        Save.profileImageURL = saveDictionary["profileImageURL"] as? String
        Save.postTime        = saveDictionary["postTime"] as? Double
        Save.documentID = saveDictionary["documentID"] as? String
        Save.rating = saveDictionary["rating"] as? String
        Save.location = saveDictionary["location"] as? String
        Save.savePostTime = saveDictionary["savePostTime"] as? String
        
        
        if let currentUserID = Auth.auth().currentUser?.uid {
            if Save.likes != nil {
                Save.isLiked = Save.likes![currentUserID]
                
            }
        }
        
        
        
    
        return Save
    }
}
