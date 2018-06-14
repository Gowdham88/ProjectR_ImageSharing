//
//  peopleViewController.swift
//  Project_R
//
//  Created by CZSM2 on 06/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit

class peopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
//    var users = [Users]()
    var users: [Users] = []
//    var userList = [String]()
//    var tagArray = [String] ()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation bar title color
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 7/255, green: 192/255, blue: 141/255, alpha: 1)]
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes
      
//        title = "Discover People"
        loadUsers()
        
    }

    func loadUsers() {
  
        self.users = []
        
        API.User.observeUser { (user) in

            self.isFollowing(userId: user.id!, completed: { (value) in
                user.isFollowing = value

                self.users.append(user)
                self.tableView.reloadData()
                
            })
        }

    }

    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        API.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            let profileVC = segue.destination as! UserViewController
            let userId = sender  as! String
            profileVC.userId = userId
            profileVC.delegate = self as? UserViewControllerDelegate
        }

//        let vc = performSegue(withIdentifier: "ProfileSegue", sender: nil)
//        self.navigationController?.pushViewController(vc, animated: true)

//        self.performSegue(withIdentifier: "ProfileSegue", sender: sender)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! peopleTableViewCell
       
       
        let user = users[indexPath.row]
        print("letuser::::\(user)")
        cell.user = user
        cell.delegate = self
        return cell
    }


}
extension peopleViewController: PeopleTableViewCellDelegate {
 
    
    func updateFollowButton(forUser user: Users) {
        
            for u in self.users {
                if u.id == user.id {
                    u.isFollowing = user.isFollowing
                    self.tableView.reloadData()
                }
            }
        
        
    }
    
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "ProfileSegue", sender: userId)
//        if segue.identifier == "ProfileSegue" {
//            let profileVC = segue.destination as! UserViewController
//            let userId = sender  as! String
//            profileVC.userId = userId
//            profileVC.delegate = self as? UserViewControllerDelegate
//        }
        
    }
    
//    func updateFollowButton(forUser user: User) {
//        for u in self.users {
//            if u.id == user.id {
//                u.isFollowing = user.isFollowing
//                self.tableView.reloadData()
//            }
//        }
//    }
}




