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
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.scrollsToTop = true
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
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func BtnBack(_ sender: UIBarButtonItem) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
