//
//  PrefsManager.swift
//  Numnu
//
//  Created by CZ Ltd on 11/17/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation

struct PrefsManager {
    
    static var sharedinstance = PrefsManager()
    
    /*Check object prefes*/
    
    func checkprefsobject(object : String) -> Bool {
        
        if UserDefaults.standard.object(forKey: object) != nil {
            
            return true
            
        } else {
            
            return false
            
        }
        
    }
    
    var lastlocation : String? {
        
        get {
            
            if checkprefsobject(object: Constants.lastlocation) {
                
                return UserDefaults.standard.string(forKey: Constants.lastlocation)!
            } else {
                
                return nil
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.lastlocation)
            
            UserDefaults.standard.synchronize()
        }
    }
    var userEmail : String {
        
        get {
            
            if checkprefsobject(object: "Email") {
                
                return UserDefaults.standard.string(forKey: "Email")!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: "Email")
            UserDefaults.standard.synchronize()
        }
    }
    
   
    
    var username : String {
        
        get {
            
            if checkprefsobject(object: "Name") {
                
                return UserDefaults.standard.string(forKey: "Name")!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: "Name")
            UserDefaults.standard.synchronize()
        }
    }
    

    
    
    var UIDfirebase : String {
        
        get {
            
            if checkprefsobject(object: "Fbid") {
                
                return UserDefaults.standard.string(forKey: "Fbid")!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: "Fbid")
            UserDefaults.standard.synchronize()
        }
    }
    
    var imageURL : String {
        
        get {
            
            if checkprefsobject(object: "Image") {
                
                return UserDefaults.standard.string(forKey: "Image")!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: "Image")

            UserDefaults.standard.synchronize()
        }
    }
    
    var isFirstTime : Bool {
        
        get {
            
            if checkprefsobject(object: "fisrttime") {
                
                return UserDefaults.standard.bool(forKey: "fisrttime")
            } else {
                
                return false
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: "fisrttime")
            
            UserDefaults.standard.synchronize()
        }
    }
    
    

    func logoutprefences() {
        
        for key in Array(UserDefaults.standard.dictionaryRepresentation().keys) {
            
            if key == "fisrttime" {
                
                return
                
            }
                
                UserDefaults.standard.removeObject(forKey: key)
        }
        
        UserDefaults.standard.synchronize()
          
    }
 
    
} // Struct
