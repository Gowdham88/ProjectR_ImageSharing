//
//  ApiClient.swift
//  Project_R
//
//  Created by CZSM G on 27/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseAuth
import FirebaseStorage
import CoreLocation


class  ApiClient {

func completeSignup(parameters : Parameters,headers : HTTPHeaders,completion : @escaping (String,Users?) -> Void) {
    
    //pass url 
    Alamofire.request("http://highavenue.co:9000/commentsnotification", method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
        
        
        print(response.result.value as Any)
        
        switch response.result {
            
        case .success:
            
            if let value = response.result.value {
                
                print(value)
                
                let json = JSON(value)
                
//                if let userList = Users(json: json) {
//
//                    completion("success",userList)
//                }
                
                
            }
            
            
        case .failure(let error):
            
            print(error.localizedDescription)
            
            if let httpStatusCode = response.response?.statusCode {
                
                if let value = response.data,httpStatusCode == 400 {
                    let json = JSON(value)
//                    if let message = Users(json: json) {
//
//                        completion("400",message)
//                        return
//                    }
                    
                }
                
            }
            
            completion(error.localizedDescription,nil)
            
        }
    }
}
    
    
}
