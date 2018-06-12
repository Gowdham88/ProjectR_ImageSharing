

import Foundation

class Users {
    var email: String?
    var profileImageURL: String?
    var username: String?
    var id: String?
    var isFollowing: Bool?
}

extension Users {
    
    static func transformUser(postDictionary: [String: Any], key: String) -> Users {
        let user = Users()
        user.email = postDictionary["email"] as? String
        user.profileImageURL = postDictionary["profileImageURL"] as? String
        user.username = postDictionary["username"] as? String
        user.id = key
        return user
    }
    
}
