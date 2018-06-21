//
//  userDetailTableViewCell.swift
//  Project_R
//
//  Created by CZSM G on 21/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit

class userDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemdetail: UILabel!
    @IBOutlet weak var itemVerified: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
