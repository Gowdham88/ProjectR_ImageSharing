//
//  NotificationViewController.swift
//  Project_R
//
//  Created by CZSM2 on 31/05/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit

protocol  NotificationViewControllerDelegate {

    func refreshPostData()
}

class NotificationViewController: UIViewController {

    
    var delegate : NotificationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation title heading - colour setting:-
         let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
