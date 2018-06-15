//
//  activity.swift
//  Project_R
//
//  Created by CZSM2 on 15/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import Foundation
import FirebaseAuth


class activity {
    
  
    var uid: String?
    var id: String?
    var userName: String?
    var currentUserName : String?
    var documentID: String?
    var currentUserUID: String?
    var activityName: String?
    
}

extension activity {
    
    static func transformActivity(activityDictionary: [String: Any], key: String) -> activity {
        
        let Activity = activity()
        
        Activity.id = key
  
        Activity.uid = activityDictionary["uid"] as? String
        
        Activity.userName = activityDictionary["userName"] as? String
        
        Activity.documentID = activityDictionary["documentID"] as? String
        
        Activity.currentUserUID = activityDictionary["currentUserUID"] as? String
        
        Activity.currentUserName = activityDictionary["currentUserName"] as? String
        
        Activity.activityName = activityDictionary["activityName"] as? String
        
        
        
        
        
        return Activity
    }
}
