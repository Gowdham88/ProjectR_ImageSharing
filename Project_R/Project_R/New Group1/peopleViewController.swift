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
      
        title = "People"
        loadUsers()
        
    }
    
    
    
    func loadUsers() {
  
       
        API.User.observeUser { (user) in
//            self.userList.append(user.id!)
//            print("userList::::\(self.userList)")
            self.isFollowing(userId: user.id!, completed: { (value) in
                user.isFollowing = value
//                uniqueElementsFrom(array: self.users)

                self.users.append(user)
                self.tableView.reloadData()
                
            })
        }

    }
    func uniqueElementsFrom<T: Hashable>(array: [T]) -> [T] {
        var set = Set<T>()
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        return result
    }
 
    
  
//    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
//        var buffer = [T]()
//        var added = Set<T>()
//        for elem in source {
//            if !added.contains(elem) {
//                buffer.append(elem)
//                added.insert(elem)
//            }
//        }
//        return buffer
//    }

    
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
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "ProfileSegue", sender: userId)
//        if segue.identifier == "ProfileSegue" {
//            let profileVC = segue.destination as! UserViewController
//            let userId = sender  as! String
//            profileVC.userId = userId
//            profileVC.delegate = self as? UserViewControllerDelegate
//        }
        
    }
}



