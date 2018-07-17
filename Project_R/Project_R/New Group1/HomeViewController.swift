//
//  HomeViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseAuth
import FirebaseStorage
import CoreLocation
import UserNotifications

///check

class HomeViewController : UIViewController {

    @IBOutlet var navigationItemList: UINavigationItem!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var apiClientID : ApiClient!
    var errormessage : String?
   
    
    var refreshControl: UIRefreshControl!
    var posts = [Post]()
    var users = [Users]()
    var snapshot :DocumentSnapshot?
    var commentCountte: Int!
    var postID: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        apiClientID = ApiClient()
        
        //Navigation title heading - colour setting:-
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // for performance set an estimated row height
        tableView.estimatedRowHeight = 571
        // but also request to dynamically adjust to content using AutoLayout
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.scrollsToTop = true
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(scrollToFirstRow(sender:)))
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.tabBarController?.delegate = self
        
        loadPosts()
        
       
        
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 44
        
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("commentCount:::\(commentCountte)")
   
            
            tabBarController?.tabBar.isHidden = false
        
    }
    
    
//    func apiPost(){
//
//        let header     : HTTPHeaders = ["Accept-Language" : "en-US"]
//        let parameters : Parameters = ["username": currentUser, "count": posts, "likedby", "postId", "tokenId"]
//
//        apiClientID.completeSignup(parameters: parameters,headers: header,completion:{status, Values in
//
//
//            print("statusfb: \(status)")
//            if status == "success" {
//
//                self.activityIndicatorView.startAnimating()
//
//                if let user = Values {
//
//                    self.getUserDetails(user: user)
//
//                    self.uploadImage(image: self.profileImage.image!, id: user.id ?? 0, completion: { imageurl in
//
//                        PrefsManager.sharedinstance.imageURL = imageurl ?? "empty"
////                        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
////                        let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
////                        vc.boolForBack = true
////                        vc.delegate    = self
////                        self.navigationController!.pushViewController(vc, animated: true)
////
//
//                    })
//
//                } else {
//
////                    LoadingHepler.instance.hide()
////                    AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "Signup failed", vc: self)
//
//                }
//
//
//            } else {
//
////                LoadingHepler.instance.hide()
//
//                if let user = Values {
//
//                    if let meassage = user.errormessage {
//
//                        if meassage.contains("There is already a user defined with the passed firebaseuid") {
//
////                            AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "The email address is already in use by another account.", vc: self)
//
//                        } else {
//
////                            AlertProvider.Instance.showAlert(title: "Oops!", subtitle: meassage, vc: self)
//
//                        }
//
//                        return
//                    }
//
//                }
//
////                AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "Signup failed", vc: self)
//
//            }
//        })
//
//
//
//    }
    
    @objc func refresh(sender:AnyObject) {
       
        posts.removeAll()
        users.removeAll()
        tableView.reloadData()
        API.Post.Recuringpoststop()
        loadPosts()
        
    }
    
    
    // MARK: - Log Out User Method
    
//    @IBAction func logout(_ sender: Any) {
//        // Log out user from Firebase
//        AuthService.signOut(onSuccess: {
//            // Present the Sign In VC
//            let storyboard = UIStoryboard(name: "Start", bundle: nil)
//            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
//            self.present(signInVC, animated: true)
//        }) { (errorMessage) in
//            ProgressHUD.showError(errorMessage)
//        }
//    }
    
    
    // MARK: - Firebase Data Loading Method
    
    
//    func loadPosts() {
//
//        API.Feed.observeFeed(withId: API.User.CURRENT_USER!.uid) { (post) in
//            guard let postUid = post.uid else {
//                return
//            }
//            self.fetchUser(uid: postUid, completed: {
//                self.posts.append(post)
//                self.tableView.reloadData()
//            })
//        }
//
//
//        API.Feed.observeFeedRemoved(withId: API.User.CURRENT_USER!.uid) { (post) in
//            self.posts = self.posts.filter { $0.id != post.id }
//            self.users = self.users.filter { $0.id != post.uid }
//
//            self.tableView.reloadData()
//        }
//    }
//
    
    
    
    func loadPosts() {
        activityIndicatorView.startAnimating()

        API.Post.observePosts { (newPost,lastsnap) in

            DispatchQueue.main.async {

            self.posts    = newPost
            self.snapshot = lastsnap
            self.activityIndicatorView.stopAnimating()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()

            }

        }
    }
    
    func loadPostsPage(snap : DocumentSnapshot) {
        activityIndicatorView.startAnimating()

        API.Post.observePostsPage(lastSnapshot: snap) { (newPost,lastsnap) in

            for item in newPost {

                self.posts.append(item)

            }

            DispatchQueue.main.async {

                self.snapshot = lastsnap
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }



        }
    }
    
    
    // fetch all user info at once and cache it into the users array
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        
        API.User.observeUser(withID: uid) { user in
            self.users.append(user)
            
            completed()
        }
    }
    
    
    // MARK: - Prepare for Segue to CommentVC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue" {
            let commentVC = segue.destination as! CommentViewController
            commentVC.postID = sender as! String
        }
    }
    
//    @IBAction func BtnInfo(_ sender: UIBarButtonItem) {
//        
////        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
////        let vc         =  storyboard.instantiateViewController(withIdentifier: "textscroll") as! TextScroll
////        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
    
    @IBAction func createNewpost(_ sender: Any) {
    
   
        let Alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let CamAction: UIAlertAction = UIAlertAction(title: "Create Post", style: .default) { ACTION in
            self.openCreatePost()
        }
        
        let GallAction: UIAlertAction = UIAlertAction(title: "Check In", style: .default){ ACTION in
            self.opencheckIn()
        }
        let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        CancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        Alert.addAction(CamAction)
        Alert.addAction(GallAction)
        Alert.addAction(CancelAction)
       
        
        Alert.popoverPresentationController?.sourceView = self.view
        Alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        present(Alert, animated: true, completion: nil)
        
        
        
    }
    func openCreatePost(){
      
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        let vc         =  storyboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func opencheckIn(){
        
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        let vc         =  storyboard.instantiateViewController(withIdentifier: "CheckInViewController") as! CheckInViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}


// MARK: - TableView Delegate and Data Source Methods

extension HomeViewController: UITableViewDataSource,UITableViewDelegate,HomeTableViewCellDelegate {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if posts.isEmpty == false
        {
            
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height:self.tableView.bounds.size.height))
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
        
        
//        cell.layer.cornerRadius = 10
//        let shadowPath2 = UIBezierPath(rect: cell.bounds)
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: CGFloat(0.5), height: CGFloat(0.5))
        cell.layer.shadowOpacity = 0.25
//        cell.layer.shadowPath = shadowPath2.cgPath
        
        guard posts.count > 0 else {
            
            return cell
        }
        
        cell.post = posts[indexPath.row]
        cell.homeVC = self
        cell.delegate = self
        cell.profileImageView.tag = indexPath.row
        cell.postImageView.tag    = indexPath.row
        cell.shareImageView.tag   = indexPath.row
        cell.nameLabel.tag        = indexPath.row
        cell.productRatingLabel.tag = indexPath.row
//        cell.postTime.tag =
//        cell.postTime.tag =
        cell.postTime.tag = indexPath.row
        cell.locationName.tag = indexPath.row
        cell.productNameLabel.tag = indexPath.row
        
        if posts[indexPath.row].value == true {
            
             cell.verifiedLbl.isHidden = false
            
        } else {
            
            cell.verifiedLbl.isHidden = true
            
        }
        
        return cell
   
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let post = posts[indexPath.row]
       
        if post.photoURL != "" {
            return 498
        } else {
            return 260
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == posts.count - 1  {

            if let pageItem = snapshot {

                loadPostsPage(snap: pageItem)

            }

        }
    }
    
    
    @objc func scrollToFirstRow(sender:UITapGestureRecognizer) {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }

    func openUserStoryboard(position: Int) {
    
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
//        vc.userId = posts[position].uid!
        userVCuserId = posts[position].uid!
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
     
    }
    
    func openImageStoryboard(position: Int) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc         =  storyboard.instantiateViewController(withIdentifier: "imagezoom") as! ImageZoom
        
        if let images = posts[position].photoURL{
            vc.imageUrl    =   images
            present(vc, animated: true, completion: nil)
        }
        
    }
    
//    func openbuyStoryboard(position: Int) {
//
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        let vc         =  storyboard.instantiateViewController(withIdentifier: "imagezoom") as! ImageZoom
//
//        if let images = posts[position].photoURL{
//            vc.imageUrl    =   images
//            present(vc, animated: true, completion: nil)
//        }
//
//    }
    
   
    
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
                        
                        self.tableView.beginUpdates()
                        self.posts.remove(at: position)
                        self.users.removeAll()
                        
                        if self.tableView.numberOfRows(inSection: position) == 1 {
                            
                            self.tableView.deleteSections(NSIndexSet(index: position) as IndexSet, with: .automatic)
                        }else{
                            self.tableView.deleteRows(at: [IndexPath(row: position, section: 0)], with: .automatic)
                            
                        }
                        
                        self.tableView.endUpdates()
                        self.tableView.reloadData()
                    }
                    
                   
                }
            }
            
        }
        
//        let reportAction = UIAlertAction(title: "Report post", style: UIAlertActionStyle.default)
//        {
//            UIAlertAction in
//
//            self.reportPostDb(post: self.posts[position])
//        }
//
//        let blockAction = UIAlertAction(title: "Block user", style: UIAlertActionStyle.default)
//        {
//            UIAlertAction in
//
//            self.blockUserDb(post: self.posts[position])
//        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            
            self.saveUserPost(post: self.posts[position])
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
//            alert.addAction(blockAction)
//            alert.addAction(reportAction)
            alert.addAction(saveAction)
            
            
        } else {
            
//            alert.addAction(reportAction)
//            alert.addAction(blockAction)
            alert.addAction(saveAction)
            
            
        }
       
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

extension HomeViewController : CameraViewControllerDelegate,UserViewControllerDelegate,ProfileViewControllerDelegate {
    
    func saveData() {
        
        posts.removeAll()
        users.removeAll()
        loadPosts()
        
    }
    
    func refreshData() {
        
        posts.removeAll()
        users.removeAll()
        loadPosts()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func refreshPostData() {
        
        posts.removeAll()
        users.removeAll()
        loadPosts()
        
    }
}


extension HomeViewController : UITabBarControllerDelegate {
    //        _ tabBarController: UITabBarController, shouldSelect viewController: UIViewController
    
//    -> Bool
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
     
            let viewController0  = tabBarController.viewControllers?[0] as! UINavigationController
//            let svc0 = viewController0.topViewController as! HomeViewController
       
        let viewController  = tabBarController.viewControllers?[1] as! UINavigationController
//            let svc = viewController.topViewController as! peopleViewController
        
        let viewController2  = tabBarController.viewControllers?[2] as! UINavigationController
            let svc1 = viewController2.topViewController as! NotificationViewController
//            svc1.delegate = self as! NotificationViewControllerDelegate
        
        let viewController3  = tabBarController.viewControllers?[3] as! UINavigationController
            let svc2 = viewController3.topViewController as! ProfileViewController
//            svc2.delegate = self;
        
        
        
        return true
    }
  
}

extension HomeViewController {
    
    
    func blockUserDb(post : Post) {
        
        
        let db = Firestore.firestore()
       
        db.collection("BlockUser").document(post.uid ?? "0000").setData([
            "uid" : post.uid ??  "empty" ,
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
            "id" : post.id ??  "empty" ,
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
    
    
    func saveUserPost(post: Post){
        
        let db = Firestore.firestore()
//        let autoID = Database.database().reference().child("save")
//        let commentsReference = autoID
//        let newCommentID = commentsReference.childByAutoId().key
        
        db.collection("posts").document(post.documentID!)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                print("Current data: \(String(describing: document.data()))")
                
                
                let postuid = post.uid
                let postphotoURL = post.photoURL
                let postCaption = post.caption
                let postLikeCount = post.likeCount
                print("postLikesCount::::\(postLikeCount)")
                let postUsername = post.userName
                let postProfileImageURL  = post.profileImageURL
                let postLikes  = post.likes
                let postDocumentID  = post.documentID
                let postRating  = post.rating
                let postLocation  = post.location
                let postPostTime = post.postTime
//                let productDetailPageURL = post.productDetailPageURL
//                let productName = post.productName
 
                
                db.collection("save").document().setData([
                    "uid" : postuid ??  "empty" ,
                    "photoURL": postphotoURL ?? "empty",
                    "caption": postCaption ?? "empty",
                    "likecount": postLikeCount!,
                    "userName"  : postUsername ?? "empty",
                    "profileImageURL" : postProfileImageURL ?? "empty",
                    "postTime": postPostTime,
                    "savePostTime": Date().timeIntervalSince1970,
                    "likes": postLikes,
                    "documentID": postDocumentID ?? "empty",
                    "rating": postRating ?? "empty",
                    "location": postLocation ?? "empty",
                    //            "likee": post.isLiked!
                    "currentUserUID": API.User.CURRENT_USER!.uid ?? "empty"
                
                    
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                        ProgressHUD.showError("Server error: \(err.localizedDescription)")
                    } else {
                        print("Document successfully written!")
                        
                    }
                }
        }

        
     
        
//        let saveRef = Firestore.firestore().collection("save").document(API.User.CURRENT_USER!.uid)
//        saveRef.getDocument { (snapshot, error) in
//            guard let _snapshot = snapshot else {return}
//
//            if !_snapshot.exists {
//                /// First time following someone
//                saveRef.setData([post.documentID!: true])
//                return
//            }
//
//            // For next time
//            var data = _snapshot.data()
//            data![post.documentID!] = true
//            saveRef.setData(data!)
//        }
        
    }
    
    func showErrorAlert(message : String){
        
        let alert = UIAlertController(title: "Hey!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
  
}
extension HomeViewController: commentCountDelegate {
    func usercommentcount(count: Int!) {
            print("count:::\(count)")
        
    }
    
  
}
