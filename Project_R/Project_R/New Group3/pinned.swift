//
//  pinned.swift
//  Project_R
//
//  Created by CZSM2 on 13/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import Foundation

import FirebaseAuth


class pinned {

//    var uid: String?
    var id: String?
   
    var documentID: String?

    
}

extension pinned {
    
    
    
    static func transformPinned(pinnedDictionary: [String: Any], key: String) -> pinned {
        let Pinned = pinned()
        
        Pinned.id = key
   
//        post.uid = postDictionary["uid"] as? String
        
        Pinned.documentID = pinnedDictionary["documentID"] as? String
     
     
        
        return Pinned
    }
    
}
