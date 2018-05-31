//
//  Comment.swift
//  Blocstagram
//
//  Created by ddenis on 1/22/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import Foundation

class Comment {
    var commentText: String?
    var uid: String?
    var id: String?
    var userName : String?
    var profileImageURL : String?
    var postTime : Double?
}

extension Comment {
    
    static func transformComment(postDictionary: [String: Any],key: String) -> Comment  {
        let comment = Comment()
        
        comment.id = key
        comment.commentText = postDictionary["commentText"] as? String
        comment.uid         = postDictionary["uid"] as? String
        comment.userName        = postDictionary["userName"] as? String
        comment.profileImageURL = postDictionary["profileImageURL"] as? String
        comment.postTime        = postDictionary["postTime"] as? Double
        
        return comment
    }
    
}
