//
//  TextScroll.swift
//  SarvodayaHB
//
//  Created by CZ Ltd on 1/30/18.
//  Copyright © 2018 CZ Ltd. All rights reserved.
//

import Foundation
import UIKit

class TextScroll: UIViewController, UITextViewDelegate {
    
//    @IBOutlet weak var label1: UILabel!
//    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var privPolicy: UILabel!
    @IBOutlet weak var policyImg: UIButton!
    @IBOutlet weak var privacyView: UIView!
    
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var termLbl: UILabel!
    @IBOutlet weak var termImg: UIButton!
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var shareImg: UIImageView!
    
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logLbl: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation title heading - colour setting:-
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 7/255, green: 192/255, blue: 141/255, alpha: 1)]
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //profile image circle view:-
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        profileImg.layer.borderWidth = 2
        profileImg.layer.borderColor = UIColor.black.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TextScroll.tappedMe))
        profileImg.addGestureRecognizer(tap)
        profileImg.isUserInteractionEnabled = true
        
        
//        textView.delegate = self
//        textView.scrollsToTop = true
//        let point = CGPoint(x: 0.0, y: (textView.contentSize.height - textView.bounds.height))
//        textView.setContentOffset(point, animated: true)
//        let range = NSMakeRange(textView.text.characters.count - 1, 0)
//        textView.scrollRangeToVisible(range)
        // Do any additional setup after loading the view.
        
//        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(show(_:sender:)))
//        navigationController?.navigationBar.topItem?.rightBarButtonItem = add
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func tappedMe()
    {
        print("Tapped on Image")

    }

    
    @IBAction func BtnBack(_ sender: UIBarButtonItem) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
