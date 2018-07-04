
//
//  UserViewController.swift
//  SarvodayaHB
//
//  Created by Suraj B on 25/01/2018.
//  Copyright © 2018 CZ Ltd. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

protocol  UserViewControllerDelegate {
    
    func refreshData()
}

var userVCuserId : String = String()
var userFollowing: Bool = Bool()

class UserViewController: UIViewController {

    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userDetail: UILabel!
    @IBOutlet weak var                                                                                                      activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var tabView: UITableView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var userdetailview: UIView!
    
    var refreshControl: UIRefreshControl!
    var posts = [Post]()
    var users = [Users]()
    var delegate : UserViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(userdetailview)
        
//        var btn: UIButton = UIButton()
//        btn.frame = CGRect(x: 100, y: 20, width: 120, height: 50)
//        btn.backgroundColor=UIColor.black
        
        print("userVCuserId: \(userVCuserId)")
        
//        btn.addTarget(self, action: #selector(normalTap(_:)), for: .touchUpInside)
//        self.userdetailview.addSubview(btn)
        
        
       
        
        
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))

        followButton.addGestureRecognizer(tapGesture)
//        btn.addGestureRecognizer(tapGesture)

        followButton.isUserInteractionEnabled = true
//        btn.isUserInteractionEnabled = true
        
//        view.superview?.addSubview(btn)
//        view.superview?.addSubview(followButton)
        
        
        tabView.scrollsToTop = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(scrollToFirstRow(sender:)))
//        self.navigationController?.navigationBar.addGestureRecognizer(tap)
//        self.navigationController?.navigationBar.isUserInteractionEnabled = true

        profileImg.layer.borderWidth = 1
        profileImg.layer.masksToBounds = false
        profileImg.layer.borderColor = UIColor.white.cgColor
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.clipsToBounds = true
        fetchUser()
        print("Step3 ::::: load post function called")
        loadPosts()
        
        self.tabView.delegate = self
        self.tabView.dataSource = self
       
    }

    func displayContentController(content: UIViewController) {
        addChildViewController(content)
        self.view.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    @IBAction func back(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
        
        if let delegateexits = delegate {
            
            delegateexits.refreshData()
            
        }
       
    }
   
    @IBAction func followButtonTapped(_ sender: Any) {
        print("Follow button tapped")
    }
    
    @objc func normalTap(_ sender: UITapGestureRecognizer){
        
        
        print("Follow Button tapped, userFollowing: \(userFollowing, userVCuserId)")
        
        
        if userFollowing == true {
            
            userFollowing = false
            
            followButton.setTitle("Follow", for: .normal)
            API.Follow.unFollowAction(withUser: userVCuserId)
            
        } else {
            
            userFollowing = true
            
            followButton.setTitle("Unfollow", for: .normal)
            API.Follow.followAction(withUser: userVCuserId)
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("Step 4 ::::: view will appear called")
        
        if userFollowing == true {
            
            
            followButton.setTitle("Unfollow", for: .normal)
            
        } else {
            
            followButton.setTitle("Follow", for: .normal)
        }
        
       
    }
    func refresh(sender:AnyObject) {
        
        posts.removeAll()
        loadPosts()
        refreshControl.endRefreshing()
    }
    
    func fetchUser() {
        
        print("Step 2 ::: fetchUser function called")
        
        print("userVCuserId: \(userVCuserId)")
        
        activityIndicatorView.startAnimating()
      
        API.User.observeUser(withID: userVCuserId, completion: { user in
            
            DispatchQueue.main.async {
                
                self.activityIndicatorView.stopAnimating()
            
            if let photoURL = user.profileImageURL {
                self.profileImg.sd_setImage(with: URL(string: photoURL))
            }
            
            if let name = user.username {
                self.userName.text = name
                self.userDetail.text = "@\(name)"
            }
                
            }
            
        })
    }
    
    func loadPosts() {
        
        activityIndicatorView.startAnimating()
        
        API.Post.observeUserPosts(withID: userVCuserId, completion: { (newPost) in
            
            DispatchQueue.main.async {
            
            self.posts = newPost
            self.activityIndicatorView.stopAnimating()
            self.tabView.reloadData()
                
            }
            
        })
    }
    @objc func scrollToFirstRow(sender:UITapGestureRecognizer) {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tabView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue2" {
            let commentVC = segue.destination as! CommentViewController
            commentVC.postID = sender as! String
        }
        
//        CommentViewController
    }
    
}

extension UserViewController : UITableViewDelegate,UITableViewDataSource,HomeTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if posts.isEmpty == false
        {
            
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tabView.bounds.size.width, height:self.tabView.bounds.size.height))
            label.text = "No post to show"
            label.textColor = UIColor.black;
            label.textAlignment = .center
            label.sizeToFit()
            label.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
            tableView.backgroundView  = label
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        
        guard posts.count > 0 else {
            
            return cell
        }

        cell.post = posts[indexPath.row]
        cell.userVC = self
        cell.delegate = self
        cell.profileImageView.tag = indexPath.row
        cell.postImageView.tag    = indexPath.row
        cell.nameLabel.tag        = indexPath.row
        
        
//        cell.productNameLabel.tag = indexPath.row
//        cell.shareImageView.tag   = indexPath.row
//        cell.productRatingLabel.tag = indexPath.row
//        cell.postTime.tag = indexPath.row
//        cell.locationName.tag = indexPath.row
      
        
        return cell

    }

    
    
    func openUserStoryboard(position: Int) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
//        vc.userId = posts[position].uid!
        userVCuserId = posts[position].uid!
        vc.delegate = self as! UserViewControllerDelegate
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func openImageStoryboard(position: Int) {
        
        let storyboard = UIStoryboard(name: "people", bundle: nil)
        let vc  =  storyboard.instantiateViewController(withIdentifier: "imagezoom") as! ImageZoom
        vc.imageUrl    =   posts[position].photoURL!
        present(vc, animated: true, completion: nil)
    }
    
    func deletePost(position: Int) {
        
        popAlert(position: position)
    }
    
    func popAlert(position: Int) {
        
        let alert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default){ action in
            
            let db = Firestore.firestore()
            db.collection("posts").document(self.posts[position].id!).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    
                    DispatchQueue.main.async {
                    
                    self.posts.removeAll()
                    self.users.removeAll()
                    self.tabView.reloadData()
                       
                    }
                    
                    self.loadPosts()
                }
            }
            
        }
        
        let reportAction = UIAlertAction(title: "Report post", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.reportPostDb(post: self.posts[position])
        }
        
        let blockAction = UIAlertAction(title: "Block user", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.blockUserDb(post: self.posts[position])
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        if currentUser.uid == self.posts[position].uid {
            
            alert.addAction(cameraAction)
            alert.addAction(blockAction)
            alert.addAction(reportAction)
            
        } else {
            
            alert.addAction(reportAction)
            alert.addAction(blockAction)
            
        }
        
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        self.present(alert, animated: true, completion: nil)
        
    }


}

extension UserViewController {
    
    
    func blockUserDb(post : Post) {
        
        let db = Firestore.firestore()
        db.collection("BlockUser").document(post.id ?? "0000").setData([
            "uid": post.uid ??  "empty" ,
            "userName"  : post.userName ?? "empty",
            "profileImageURL" : post.profileImageURL ?? "empty"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
                ProgressHUD.showError("Server error: \(err.localizedDescription)")
            } else {
                print("Document successfully written!")
                self.showErrorAlert(message: "We will process your request as soon as possible.")
                
            }
        }
        
        
    }
    
    func reportPostDb(post : Post) {
        
        let db = Firestore.firestore()
        db.collection("ReportPost").document(post.uid ?? "0000").setData([
            "id": post.id ??  "empty" ,
            "caption": post.caption ?? "empty",
            "userName"  : post.userName ?? "empty",
            "profileImageURL" : post.profileImageURL ?? "empty"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
                ProgressHUD.showError("Server error: \(err.localizedDescription)")
            } else {
                print("Document successfully written!")
                self.showErrorAlert(message: "Your report is under processing stage.It will take one day.")
                
            }
        }
        
        
    }
    
    func showErrorAlert(message : String){
        
        let alert = UIAlertController(title: "Hey!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}




