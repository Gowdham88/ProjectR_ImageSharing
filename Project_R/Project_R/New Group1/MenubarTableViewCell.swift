//
//  MenubarTableViewCell.swift
//  Project_R
//
//  Created by CZSM2 on 12/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit
import Nuke


class MenubarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productDescription: UILabel!
    
    @IBOutlet weak var verify: UILabel!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    func updateView() {
        if let photoURL = post?.photoURL {
            productImage.image = nil
            if  photoURL != "" {
                Manager.shared.loadImage(with: URL(string : photoURL)!, into: self.productImage)
            }
        }
        
        productName.text = "4K Display iMac"
        productDescription.text = post?.caption
        
    }
    
    func saceUpadteView(){
        
        
    }
}
