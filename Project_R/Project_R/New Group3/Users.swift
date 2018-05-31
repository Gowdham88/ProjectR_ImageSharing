

import Foundation

class Users {
    var email: String?
    var profileImageURL: String?
    var username: String?
}

extension Users {
    
    static func transformUser(postDictionary: [String: Any]) -> Users {
        let user = Users()
        
        user.email = postDictionary["email"] as? String
        user.profileImageURL = postDictionary["profileImageURL"] as? String
        user.username = postDictionary["username"] as? String
        
        
        return user
    }
    
}
