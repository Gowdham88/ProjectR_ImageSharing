//
//  UserAPI.swift
//  Blocstagram
//
//  Created by ddenis on 1/24/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage


class UserAPI {
    
    var REF_USERS = Database.database().reference().child("users")
    var globalhandler : DatabaseHandle?
    let db = Firestore.firestore()
    var listner : ListenerRegistration?
    var userList = [Users]()

    var CURRENT_USER: FirebaseAuth.User? {
        
        if let currentUser  = Auth.auth().currentUser {
            return currentUser
        }
        
        return nil
    }
    
    var CURRENT_USER_ID = Auth.auth().currentUser?.uid
    
    var REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        return REF_USERS.child(currentUser.uid)
    }
    
    func observeCurrentUser(completion: @escaping (Users) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let docRef = db.collection("users").document(currentUser.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                
                let user = Users.transformUser(postDictionary: document.data()!)
                completion(user)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func observeUser(withID uid:String, completion: @escaping (Users) -> Void) {
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                
                let user = Users.transformUser(postDictionary: document.data()!)
                completion(user)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func observeUser(completion: @escaping ([Users]) -> Void) {
        
        db.collection("users")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    self.userList.removeAll()
                    
                    for document in querySnapshot!.documents {
                        
                        let user = Users.transformUser(postDictionary: document.data())
                        self.userList.append(user)
                    }
                    
                    completion(self.userList)
                    
                }
        }
    }
    
    func Recuringuserstop() {
        
        if let handle = self.listner {
            
            handle.remove()
        }
       
        
    }
    
    func UploadImage(imageData : Data,onSuccess: @escaping () -> Void) {
        
        let user = Auth.auth().currentUser
        let uid = user?.uid
        
        // get a reference to our file store
        let storeRef = Storage.storage().reference(forURL: Constants.fileStoreURL).child("profile_image").child(uid!)
        
        storeRef.putData(imageData, metadata: nil, completion: { (metaData, error) in
            if error != nil {
                print("Profile Image Error: \(String(describing: error?.localizedDescription))")
                return
            }
            // if there's no error
            // get the URL of the profile image in the file store
            let profileImageURL = metaData?.downloadURL()?.absoluteString
           
            self.setUserProfileImage(profileImageURL: profileImageURL!, uid: uid!, onSuccess: onSuccess)
        })
        
        
    }
    
    // MARK: - Firebase Saving Methods
    
     func setUserProfileImage(profileImageURL: String, uid: String, onSuccess: @escaping () -> Void) {
        // create the new user in the user node and store username, email, and profile image URL
        
        let Ref = db.collection("users").document(uid)
        
        // Set the "capital" field of the city 'DC'
        Ref.updateData([
            "profileImageURL": profileImageURL
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                PrefsManager.sharedinstance.imageURL = profileImageURL
            }
        }
        onSuccess()
    }
    
    func setUserProfileName(profilename: String, onSuccess: @escaping () -> Void){
        // create the new user in the user node and store username, email, and profile image URL
        let user = Auth.auth().currentUser
        let uid = user?.uid
       let Ref = db.collection("users").document(uid!)
        
        // Set the "capital" field of the city 'DC'
        Ref.updateData([
            "username": profilename
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                PrefsManager.sharedinstance.username  = profilename
            }
        }
        onSuccess()
    }

}
