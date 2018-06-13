//
//  SliderDesign.swift
//  Project_R
//
//  Created by CZSM G on 13/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import Foundation

import UIKit
@IBDesignable
class SliderDesign: UISlider {
    
    @IBInspectable var thumbImage: UIImage? {
        
        didSet {
            
            setThumbImage(thumbImage, for: .normal)
            
        }
    }
    
}

