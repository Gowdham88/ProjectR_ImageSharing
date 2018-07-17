//
//  peopleViewController.swift
//  Project_R
//
//  Created by CZSM2 on 06/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class peopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var followers   : [String : Any]?
    
    var refreshControl = UIRefreshControl()
   
    var users : [Users] = []
    var userDat: Users!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation bar title color
        
        loadUsers()

        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
    }
 
   
    @objc func refresh(sender:AnyObject) {
        
        refreshControl.endRefreshing()

    }


    func openUserStoryboard(position: Int) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        //        vc.userId = posts[position].uid!
        userVCuserId = posts[position].uid!
        vc.delegate = self as! UserViewControllerDelegate
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func loadUsers() {
        
        self.activityIndicator.startAnimating()

        API.User.observeUser { (user) in

//            for item in user {

            self.isfollowing(userId: user.id!, completed: { (value) in

                    user.isFollowing = value

                    print("printing followers \(user.id), status \(user.isFollowing)")

                    self.users.append(user)
//                    self.loadFollowers()
                 self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                    self.tableView.reloadData()

                })

//            }

        }
    }
    
    func isfollowing(userId : String ,completed : @escaping(Bool) -> Void) {
        
        API.Follow.isFollowing(userId: userId, completed: completed )
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ProfileSegue" {

            let profileVC = segue.destination as! UserViewController
            let userId = sender  as! String

            //            profileVC.userId = userId
            
            print("People View controller Prepare for Segue: \(userId)")
            
            userVCuserId = userId
            profileVC.delegate = self as? UserViewControllerDelegate
            
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of user",users.count)
        return users.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! peopleTableViewCell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToUserPage(sender:)))
        cell.profileUserImage.addGestureRecognizer(tapGesture)
        cell.profileUserImage.isUserInteractionEnabled = true
        
        cell.followBtn.tag = indexPath.row
        
        if users.count > 0 {
        
            let user1 = users[indexPath.row]
            cell.user = user1
            cell.delegate = self
            
        }
   
        return cell
    }
    
    var posts = [Post]()

    @objc func moveToUserPage(sender: UITapGestureRecognizer) {
        
        print("User detail page tapped \(sender)")
        
        let tapLocation = sender.location(in: tableView)
        let indexPath : IndexPath = tableView.indexPathForRow(at: tapLocation)!
        print("moveToUserPage indexPath.row: \(indexPath.row)")

        userVCuserId = users[indexPath.row].id!
        
        print("users.count \(users.count)")
 
            let id = users[indexPath.row].id
        print("get user ID::::", id)
        
        if let followbool = users[indexPath.row].isFollowing {
            userFollowing = followbool
            print("Get boolean for Followers:::::",userFollowing)
        }

        print("moveToUserPage userVCuserId: \(userVCuserId)")
        print("userFollowing: \(userFollowing)")
        
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
            let navigationController = UINavigationController(rootViewController: vc)
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension peopleViewController: PeopleTableViewCellDelegate {
   
    func updateFollowers(position: Int, cell: peopleTableViewCell) {
        
        print("::GET DETAIL OF OF FOLLOWERS-1::",updateFollowers)
        
        API.Follow.followAction(withUser: users[position].id ?? "empty")
   
        if API.User.CURRENT_USER_ID == users[position].id {
            
            print("Get my user ID::.:", API.User.CURRENT_USER_ID)
            
        } else {
            
            print("::GET DETAIL OF OF FOLLOWERS-2::",updateFollowers)
            cell.configureUnFollowButton()
            
            self.tableView.reloadData()
        }
    }
    
    func updateUnFollowers(position: Int, cell: peopleTableViewCell) {
        
        print("updateUnFollowers:::")
        API.Follow.unFollowAction(withUser: users[position].id ?? "empty")
        cell.configureFollowButton()
        self.tableView.reloadData()
    }
 
 
    func goToProfileUserVC(userId: String) {
        
        performSegue(withIdentifier: "ProfileSegue", sender: userId)

    }
    
}

extension peopleViewController: HeaderProfileCollectionReusableViewDelegate {
    
    func updateFollowButton(forUser user: Users) {

        for u in users {
            if u.id == user.id {
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
            }
        }

    }
}
