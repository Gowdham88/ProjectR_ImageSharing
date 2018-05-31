//
//  ProfileHeaderCollectionReusableView.swift
//  Blocstagram
//
//  Created by Dulio Denis on 1/31/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate {
    
    func upload()
    func editname()
}


class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    var delegate : ProfileHeaderCollectionReusableViewDelegate?
    
    var user: Users? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        self.nameLabel.text = user?.username
        
        if let photoURL = user?.profileImageURL {
            self.profileImageView.sd_setImage(with: URL(string: photoURL))
        }
    }
    
    @IBAction func ButtonProfile(_ sender: UIButton) {
        
        delegate?.upload()
    }
    
    
    @IBAction func ButtonEditName(_ sender: UIButton) {
        
        delegate?.editname()
    }
}
