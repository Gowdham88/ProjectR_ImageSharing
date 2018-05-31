//
//  PhotoCollectionViewCell.swift
//  Blocstagram
//
//  Created by Dulio Denis on 3/5/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import Nuke

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let photoURL = post?.photoURL {
           photoView.image = nil
           Manager.shared.loadImage(with: URL(string : photoURL)!, into: self.photoView)
            
        }
    }
    
}
