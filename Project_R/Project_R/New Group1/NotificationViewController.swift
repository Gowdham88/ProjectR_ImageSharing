//
//  NotificationViewController.swift
//  Project_R
//
//  Created by CZSM2 on 31/05/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit

var notificationMessages = [String]()

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var myTableview: UITableView!
    
//    var delegate : NotificationViewControllerDelegate?
//
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = myTableview.reus
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifycell", for: indexPath) as! NotificationTableViewCell
        
        cell.notifyLabel.text = "Test"
        
        return cell
        
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
