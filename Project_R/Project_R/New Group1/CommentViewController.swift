//
//  CommentViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/20/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

protocol  commentCountDelegate {
    
    func usercommentcount(count:Int!)
    
}

class CommentViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    var postID: String!
    var comments = [Comment]()
    var Sortingcomments   = [SortComment]()
    var users = [Users]()
    var commentCount: Int!
    var delegate: commentCountDelegate?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comments"
        
        // for performance set an estimated row height
        tableView.estimatedRowHeight = 70
        // but also request to dynamically adjust to content using AutoLayout
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate   = self
        tableView.dataSource = self

        handleTextField()
        prepareForNewComment()
        loadComments()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(keyboardWillhide(_:)))
        tableView.addGestureRecognizer(tap)
        
        // Set Keyboard Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func backBtn(_ sender: Any) {
        
        
        if let delegatee = delegate {
            
            delegatee.usercommentcount(count: commentCount)
        }
//         _ = self.navigationController?.popToRootViewController(animated: true)
       
        
//
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        let vc =  storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        print("comment\(commentCount)")
        
     
        
        self.navigationController?.popViewController(animated: true)
        
       
        
     }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Keyboard Notification Response Methods
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillhide(_ notification: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
            self.view.endEditing(true)
        }
    }
   
    
    // MARK: - Firebase Save Operation
    
    @IBAction func send(_ sender: Any) {
        
        disableButton()
        
        guard let commenttext = self.commentTextField.text else {
            
            ProgressHUD.showError("Comment is empty.")
            return
        }
        
        if self.commentTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
           
            ProgressHUD.showError("Comment is empty.")
            return
        }

        
        let commentsReference = API.Comment.REF_COMMENTS
        let newCommentID = commentsReference.childByAutoId().key
        
        
        guard let currentUser = API.User.CURRENT_USER else { return }
        let currentUserID = currentUser.uid
        
        var users : Users!
        API.User.observeCurrentUser { user in
            users = user
            
           guard let userName = users.username,let userImage = users.profileImageURL else {
            
                ProgressHUD.showError("Server error.")
                return
            
            }
            
            self.prepareForNewComment()
            
            
            let db = Firestore.firestore()
            db.collection("comments").document(newCommentID).setData([
                "uid": currentUserID,
                "commentText": commenttext,
                "postid" : self.postID,
                "userName"  : userName,
                "profileImageURL" : userImage,
                "postTime"        : Date().timeIntervalSince1970,
                ]){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                        ProgressHUD.showError("Error : \(err.localizedDescription)")
                    } else {
                        
                        self.prepareForNewComment()
                        self.view.endEditing(true)
                        self.loadComments()
                    }
            }
            
        }
        
        
    }
    
    
    // MARK: - Load Comments from Firebase
    
    func loadComments() {
        
        self.comments.removeAll()
        self.Sortingcomments.removeAll()
        self.users.removeAll()
        
        activityIndicator.startAnimating()
        
        let db = Firestore.firestore()
        let docRef = db.collection("comments").whereField("postid", isEqualTo: self.postID).limit(to: 500)
        
        docRef.getDocuments() { (querySnapshot, err) in
            self.commentCount = querySnapshot?.count
            print("countComment1::::\(String(describing: self.commentCount))")

            if let err = err {
                print("Error getting documents: \(err)")
                self.activityIndicator.stopAnimating()
            } else {
//                self.commentCount = querySnapshot?.count
//                print("countComment::::\(String(describing: self.commentCount))")
                self.activityIndicator.stopAnimating()
                
                for document in querySnapshot!.documents {
                    
                    let newComment = Comment.transformComment(postDictionary: document.data(),key: document.documentID)
                    print("newComment::::\(newComment)")
                    self.Sortingcomments.append(SortComment(SortingCommentList: newComment, timestamp: newComment.postTime ?? 0))
                  
                }
                
                let commentListPrimary = self.Sortingcomments.sorted {
                    $0.timestamp < $1.timestamp
                }
                
                for item in commentListPrimary {
                    
                    self.comments.append(item.SortingCommentList)
                    
                }
                
                DispatchQueue.main.async {
                
                self.tableView.reloadData()
                self.scrollToBottom()
                    
                }
            }
        }
       
    }
    
    func scrollToBottom(){
        
        guard comments.count > 0 else {
            
            return
        }
        
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.comments.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    
    
    // fetch all user info at once and cache it into the users array
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        API.User.observeUser(withID: uid) { user in
                self.users.append(user)
                
                completed()
            }
    }
    
    
    // MARK: - UI Methods
    
    func prepareForNewComment() {
        commentTextField.text = ""
        disableButton()
    }
    
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let comment = commentTextField.text, !comment.isEmpty else {
            // disable Send button if comment is blank and return
            disableButton()
            return
        }
        // otherwise enable the Send button
        enableButton()
    }
    
    func enableButton() {
        sendButton.alpha = 1.0
        sendButton.isEnabled = true
    }
    
    func disableButton() {
        sendButton.alpha = 0.2
        sendButton.isEnabled = false
    }
    
    
}


// MARK: - TableView Delegate and Data Source Methods

extension CommentViewController: UITableViewDataSource,UITableViewDelegate,CommentTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if comments.isEmpty == false
        {
            
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height:self.tableView.bounds.size.height))
            label.text = "No comments to show"
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
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        
        guard comments.count > 0 else {
            
            return cell
        }
        
        cell.comment = comments[indexPath.row]
        cell.delegate = self
        cell.profileImageView.tag = indexPath.row
        cell.nameLabel.tag        = indexPath.row
        cell.commentLabel.tag     = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        popAlert(position: indexPath.row)
    }
    
    func popAlert(position: Int) {
        
        print(position)
        
        let alert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default){ action in
            
            let db = Firestore.firestore()
            db.collection("comments").document(self.comments[position].id!).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    
                    DispatchQueue.main.async {
                    
                    self.tableView.beginUpdates()
                    self.comments.remove(at: position)
                    self.Sortingcomments.remove(at: position)
                    
                    
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func updateComments(position: Int) {
        
        popAlert(position: position)
    }
    
}


