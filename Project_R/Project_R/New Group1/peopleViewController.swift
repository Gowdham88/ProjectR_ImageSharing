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

var users       : [Users] = []

class peopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var followers   : [String : Any]?
    
    var newUsers: [Users] = []
    var newListOfUsers:[Users] = []
    var activityIndicator = UIActivityIndicatorView()
    
//    var userList = [String]()
//    var tagArray = [String] ()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation bar title color
         let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes
      
//        title = "Discover People"
        
       
//        removeMyDuplicates()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
         loadUsers()
    }

    func loadUsers() {
        
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        
        users.removeAll()
  
        API.User.observeUser { (user) in
            
            let tempArray = user
            print("Get temp array::::", tempArray)
//            self.users = user
            
            for item in user {
                if API.User.CURRENT_USER_ID == item.id
                {
                    print("Get my user detail id::::",API.User.CURRENT_USER_ID)
                }
                else {
                    
                    users.append(item)
                    print("Appened users::::", users)

                }
            }
            
            print("Print loadusers::::", users)
            
            self.loadFollowers()
            
//            self.activityIndicator.stopAnimating()
//            self.activityIndicator.isHidden = true
          
        }
        
    }
    
    
    func loadFollowers() {
        
        if followers != nil {
            
            followers?.removeAll()
        }
        
        let userId = API.User.CURRENT_USER_ID ?? "empty"
        
        print(userId)
        
        API.Follow.isFollowing(userId: userId, completed: { (followersList) in
            
            if let followerslist = followersList
            {
                
                self.followers = followerslist
                print("Get followers list::::", followersList!,self.followers)
                
            }
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
           
        })
        
    }
    
    func removeMyDuplicates(){

        for user in users{
            var added = false
            for newUser in self.newListOfUsers{
                if(user.id == newUser.id){
                    added = true
                }
            }
            if !added{
                newUsers.append(user)
            }
        }
        users = newUsers
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
        print("Number of user",users.count)
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! peopleTableViewCell
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToUserPage(sender:)))
        cell.profileUserImage.addGestureRecognizer(tapGesture)
        cell.profileUserImage.isUserInteractionEnabled = true
        cell.followers = self.followers
       
        cell.followBtn.tag = indexPath.row
        
        print("indexPath.row: \(indexPath.row)")
        
        let user = users[indexPath.row]
        print("letuser::::\(user)")
        cell.user = user
        cell.delegate = self
        
        let isFollowing = users[indexPath.row].isFollowing
        print("isFollowing cellForRowAt: \(isFollowing)")

        if isFollowing != nil && isFollowing == true  {

            
            cell.followBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            cell.followBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cell.followBtn.backgroundColor = UIColor.clear
            cell.followBtn.setTitle("Following", for: .normal)
            
        } else {
            
            cell.followBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            
            cell.followBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            cell.followBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            
            cell.followBtn.setTitle("Follow", for: .normal)
            
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
    
    func updateFollowers(position: Int) {
        
        API.Follow.followAction(withUser: users[position].id ?? "empty")
        
        if API.User.CURRENT_USER_ID == users[position].id {
            
            print("Get my user ID:::", API.User.CURRENT_USER_ID)
            
        } else {
        
        loadFollowers()
            
        }
       
    }
    
    func updateUnFollowers(position: Int) {
        
        API.Follow.unFollowAction(withUser: users[position].id ?? "empty")
        loadFollowers()
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




