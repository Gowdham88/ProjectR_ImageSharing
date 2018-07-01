//
//  userDetailTableViewCell.swift
//  Project_R
//
//  Created by CZSM G on 21/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit
import Nuke

class userDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var userProduct: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemdetail: UILabel!
    @IBOutlet weak var itemVerified: UILabel!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var saves: save? {
        
        didSet {
            
            saveUpadteView()
            
        }
        
    }
    
    var activities: activity? {
        
        didSet {
            
            activityUpadteView()
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userProduct.layer.cornerRadius = userProduct.frame.size.width / 2
        userProduct.clipsToBounds = true
       
    }
    
    func updateView() {
        if let photoURL = post?.photoURL {
            userProduct.image = nil
            if  photoURL != "" {
                Manager.shared.loadImage(with: URL(string : photoURL)!, into: self.userProduct)
            }
        }
    
        
        itemName.text = "4K Display iMac"
        itemdetail.text = post?.caption

    }
    
    func saveUpadteView(){
        
        if let photoURL = saves?.photoURL {
            
            userProduct.image = nil
            if photoURL != "" {
                
                Manager.shared.loadImage(with: URL(string: photoURL)!, into: self.userProduct)
            }
            
        }
        
        itemName.text = "4K Display iMac"
        itemdetail.text = post?.caption
    }
    
    func activityUpadteView(){
        
//        itemdetail.text = activities?.activityName
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}


