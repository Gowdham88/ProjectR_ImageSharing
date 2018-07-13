//
//  ProductList.swift
//  HighAvenue
//
//  Created by CZSM G on 12/07/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import Foundation

class productList: NSObject {
    var photoURL                    : String?
    var productDetailPageURL        : String?
    var productName                 : String?
   
    
    init?(dictionary                : [String : Any]) {
        super.init()
        
        
        photoURL                    = dictionary["photoURL"] as? String ?? "error"
        productDetailPageURL        = dictionary["productDetailPageURL"] as? String ?? "error"
        productName                 = dictionary["productName"] as? String  ?? "error"
       
    }
}

