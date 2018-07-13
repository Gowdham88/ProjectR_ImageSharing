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


class peopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var followers   : [String : Any]?
    
    var refreshControl = UIRefreshControl()
   
    var users : [Users] = []
    var userDat: Users!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation bar title color
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
         loadUsers()
        
       
            
        
        
        
        
    }
    
    @objc func refresh(sender:AnyObject) {
        
        refreshControl.endRefreshing()

    }

//    func loadUsers() {
//
//        print("Load Users called")
//
//        self.activityIndicator.startAnimating()
//        self.activityIndicator.isHidden = false
//
//        users.removeAll()
//
//
//        API.User.observeUser { (user) in
//
//            let tempArray = user
//
//            print("Get temp array::::", tempArray)
////            self.users = user
//
////            for item in user. {
//                if API.User.CURRENT_USER_ID == user.id
//                {
//                    print("Get my user detail id::::",API.User.CURRENT_USER_ID)
//                }
//                else {
//                    print("printing item \(user)")
//                    self.users.append(user)
//
//                }
////            }
//
//
//            self.loadFollowers()
//
////            self.activityIndicator.stopAnimating()
////            self.activityIndicator.isHidden = true
//
//        }
//
//    }
//
    func loadUsers() {

        API.User.observeUser { (user) in

//            for item in user {

            self.isfollowing(userId: user.id!, completed: { (value) in

                    user.isFollowing = value

                    print("printing followers \(user.id), status \(user.isFollowing)")

                    self.users.append(user)
//                    self.loadFollowers()
                    self.tableView.reloadData()

                })

//            }

        }
    }
    
    func isfollowing(userId : String ,completed : @escaping(Bool) -> Void) {
        
        API.Follow.isFollowing(userId: userId, completed: completed )
    }
    
//    func loadFollowers() {
//
//
//        if followers != nil {
//
//            followers?.removeAll()
//        }
//
//        let userId = API.User.CURRENT_USER_ID ?? "empty"
//
//        self.tableView.reloadData()
//
//        API.Follow.isFollowingTemp(userId: userId) { (followerList) in
//
//            if let followerslist = followerList as [String:Any]?
//            {
//
//                self.followers = followerslist
//                print("Get followers list::::", followerslist)
//
//            }
//
//
//        }
//
////        API.Follow.isFollowing(userId: userId, completed: { (followersList) in
////
////            if let followerslist = followersList
////            {
////
////                self.followers = followerslist
////                print("Get followers list::::", followersList!)
////
////            }
//
//
//
////            DispatchQueue.main.async {
//
//
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.isHidden = true
////            }
//
//
//
//    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ProfileSegue" {

            let profileVC = segue.destination as! UserViewController
            let userId = sender  as! String

            //            profileVC.userId = userId
            
            print("People View controller Prepare for Segue: \(userId)")
            
            userVCuserId = userId
            profileVC.delegate = self as? UserViewControllerDelegate
            
        }

//        let vc = performSegue(withIdentifier: "ProfileSegue", sender: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.performSegue(withIdentifier: "ProfileSegue", sender: sender)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismiss(animated: true, completion: nil)
//        tabBarController?.tabBar.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of user",users.count)
        
        return users.count
        
    }
//
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        activityIndicator.startAnimating()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! peopleTableViewCell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToUserPage(sender:)))
        cell.profileUserImage.addGestureRecognizer(tapGesture)
        cell.profileUserImage.isUserInteractionEnabled = true
//        cell.followers = self.followers
               
        cell.followBtn.tag = indexPath.row
        
//        let user = users[indexPath.row]
        if users.count > 0 {
        
            let user1 = users[indexPath.row]
            cell.user = user1
            cell.delegate = self
            
        
            
        }
    
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        

 
        
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
        
        if let followbool = users[indexPath.row].isFollowing {
            
            userFollowing = false
            
            
        } else {
            
            userFollowing = true
        }

        
        print("moveToUserPage userVCuserId: \(userVCuserId)")
        print("userFollowing: \(userFollowing)")
        
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        
        let navigationController = UINavigationController(rootViewController: vc)
        
            self.navigationController?.pushViewController(vc, animated: true)
        

    }
    
//    func displayContentController(content: UIViewController) {
//        addChildViewController(content)
//        self.view.addSubview(content.view)
//        content.didMove(toParentViewController: self)
//    }

}
extension peopleViewController: PeopleTableViewCellDelegate {
   
    func updateFollowers(position: Int, cell: peopleTableViewCell) {
        
        print("::GET DETAIL OF OF FOLLOWERS-1::",updateFollowers)
        
        API.Follow.followAction(withUser: users[position].id ?? "empty")
       
        
//        cell.configureUnFollowButton()

//        self.tableView.reloadData()
        
        
        if API.User.CURRENT_USER_ID == users[position].id {
            
            print("Get my user ID:::", API.User.CURRENT_USER_ID)
            
        } else {
            
            print("::GET DETAIL OF OF FOLLOWERS-2::",updateFollowers)
            
//            loadFollowers()
             cell.configureUnFollowButton()
            
            self.tableView.reloadData()
            
            
        }
    }
    
    func updateUnFollowers(position: Int, cell: peopleTableViewCell) {
        
        print("updateUnFollowers:::")
        
//        self.tableView.reloadData()
        
        API.Follow.unFollowAction(withUser: users[position].id ?? "empty")
//        loadFollowers()
        cell.configureFollowButton()

        self.tableView.reloadData()
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




