//
//  NotificationViewController.swift
//  Project_R
//
//  Created by CZSM2 on 31/05/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

var notificationMessages = [String]()

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var myTableview: UITableView!
    
    var db = Firestore.firestore()

    
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
        
        getValuesFromTable()

        // Do any additional setup after loading the view.
    }
    
    var notificationString : String!

    func getValuesFromTable() {
        
        db.collection("Notifications").document((API.User.CURRENT_USER?.uid)!).getDocument { (document, error) in
            
            if let document = document, document.exists {
                
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                print("Document data: \(dataDescription)")
                
                if let stringg = document["notification"] {
                    
                    self.notificationString = stringg as! String
                    print("string print \(stringg)")
                    
                    self.myTableview.reloadData()

                }
                
            } else {
                
                print("Document does not exist")
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifycell", for: indexPath) as! NotificationTableViewCell
        
        cell.notifyLabel.text = notificationString
        
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
