//
//  TermsServiceController.swift
//  SarvodayaHB
//
//  Created by CZ Ltd on 2/7/18.
//  Copyright © 2018 CZ Ltd. All rights reserved.
//

import UIKit

class TermsServiceController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.scrollsToTop = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func BtnClose(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
