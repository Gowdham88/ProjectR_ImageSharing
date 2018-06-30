//
//  ProfileViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol  ProfileViewControllerDelegate {
    
    func refreshPostData()
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var MenuBar: CustomSegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: Users!
    var posts: [Post] = []
    var countpost : [Post] = []
    var countuser : [Users] = []
    var postCountsss: Int?
    var post = [Post]()
    var saves = [save]()
    var activities = [activity]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedProfilePhoto: UIImage?
    var tField : UITextField = UITextField()
    var delegate : ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation title heading - colour setting:-
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchUser()
//        tableView.reloadData()
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchUser()
        fetchMyPosts(completion: { status in
            
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
            

        })
        fetchMYSaves(completion: { status in
        
        
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
        
        })
        
        fetchMYActivity(completion:  { status in
            
            
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
            
        })
    }
    
   
    
    func fetchUser() {
        
        activityIndicator.startAnimating()
        
        API.User.observeCurrentUser { user in
            
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                self.user = user
                self.collectionView.reloadData()
            }
         
        }
    }
    
    func fetchMyPosts(completion: @escaping (String) -> Void) {
        posts.removeAll()
        activityIndicator.startAnimating()
        guard let currentUser = Auth.auth().currentUser else {
            self.activityIndicator.stopAnimating()
            return
        }
        
        API.Post.observeUserPosts(withID: currentUser.uid, completion: {
            post in
            self.posts = post
            completion("success")
        })
        
        
    }
    
    
    func fetchMYSaves(completion: @escaping (String) -> Void) {
        
        saves.removeAll()
        activityIndicator.startAnimating()
        guard let currentUser = Auth.auth().currentUser else {
            self.activityIndicator.stopAnimating()
            return
        }
        API.MySaves.observeUserSaves(withID: currentUser.uid, completion: {
            
            savee in
            self.saves = savee
            completion("Success")
            
        })
        
    }
    
    
    func fetchMYActivity(completion: @escaping (String) -> Void) {
        
        activities.removeAll()
        activityIndicator.startAnimating()
        guard let currentUser = Auth.auth().currentUser else {
            self.activityIndicator.stopAnimating()
            return
        }
        API.MyActivity.observeUserSaves(withID: currentUser.uid, completion: {
            
            activitee in
            self.activities = activitee
            completion("Success")
            
        })
       
    }
    
    func fetchPostCount(completion: @escaping (String) -> Void) {
        
//        self.countpost.removeAll()
//        API.Post.Recuringpoststop()
//        API.Post.observePosts { (newPost) in
//
//            self.countpost = newPost
//
//            completion("success")
//        }
        
        
    }
    
//    @IBAction func logOut(_ sender: Any) {
//        // Log out user from Firebase
//        AuthService.signOut(onSuccess: {
//            // Present the Sign In VC
//            let storyboard = UIStoryboard(name: "Start", bundle: nil)
//            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
//            self.present(signInVC, animated: true)
//        }) { (errorMessage) in
//            ProgressHUD.showError(errorMessage)
//        }
//    }
    func fetchUserCount() {
        
        self.collectionView.reloadData()
        self.tableView.reloadData()
        
//        self.countuser.removeAll()
//        API.User.Recuringuserstop()
//        API.User.observeUser  { (user) in
//
//            self.countuser = user
//            self.collectionView.reloadData()
//        }
        
    }
    
    @IBAction func settingBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TextScroll") as! TextScroll
        self.navigationController?.pushViewController(vc, animated: true)
        
//        performSegue(withIdentifier: "settings", sender: self)
        
//        let alert = UIAlertController(title: "Change username", message: "Enter your username", preferredStyle: .alert)
//
//        alert.addTextField(configurationHandler: configurationTextField)
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:handleCancel))
//
//        alert.addAction(UIAlertAction(title: "Save", style: .default, handler:{ (UIAlertAction) in
//
//            if let email = self.tField.text {
//                if email.count > 0 {
//                    ProgressHUD.show("Updating...", interaction: true)
//                    API.User.setUserProfileName(profilename: email, onSuccess: {
//
//                        ProgressHUD.showSuccess("Saved successfully.")
//                        self.fetchUser()
//
//                    })
//                }else {
//                    ProgressHUD.showError("Username cannot be empty")
//
//                }
//
//            } else {
//
//                ProgressHUD.showError("Enter username")
//            }
//
//
//            
//        }))
//
//        self.present(alert, animated: true, completion: {
//
//            print("completion block")
//
//        })
        
    }
    
    @IBAction func SegmentChanged(_ sender: UISegmentedControl) {
        
       

        
    }
    
    @IBAction func customSegmentValueChanged(_ sender: CustomSegmentedControl) {
        
//        switch sender.selectedSegmentIndex {
//        case 0:
//            UIView.animate(withDuration: 0.3, animations: {
//
//
//
//            })
//
//        case 1:
//
//            UIView.animate(withDuration: 0.3, animations: {
//
//
//
//            })
//
//
//        default:
//            //3rd segment
//
//            UIView.animate(withDuration: 0.3, animations: {
//
//
//
//            })
//            break
//        }
        
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnValue = 0
        
        switch(MenuBar.selectedSegmentIndex)
        {
        case 0:
            returnValue = posts.count
            break
        case 1:
            returnValue = saves.count
            break
            
        case 2:
            returnValue = activities.count
            break
            
        default:
            break
            
        }
        
        return returnValue
//        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenubarTableViewCell
       
        switch(MenuBar.selectedSegmentIndex)
       
        {
        case 0:

            cell.post = posts[indexPath.row]
            
            cell.activityComments.isHidden = true
            cell.productName.isHidden = false
            cell.productImage.isHidden = false
            cell.productDescription.isHidden = false
            cell.verify.isHidden = false
            
            break
        case 1:
            
            cell.saves = saves[indexPath.row]
            
            cell.activityComments.isHidden = true
            cell.productName.isHidden = false
            cell.productImage.isHidden = false
            cell.productDescription.isHidden = false
            cell.verify.isHidden = false
            
            break
            
        case 2:
            
            cell.activities = activities[indexPath.row]
            
            cell.activityComments.isHidden = false
            cell.productName.isHidden = true
            cell.productImage.isHidden = true
            cell.productDescription.isHidden = true
            cell.verify.isHidden = true
            
            break
            
        default:
            break
            
        }
        
        return cell
    }
    
    


}




extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
//
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell

//        guard posts.count > 0 else {
//
//            return cell
//        }

//        cell.post = posts[indexPath.row]

        collectionView.isScrollEnabled = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileHeaderCollectionReusableView", for: indexPath) as! ProfileHeaderCollectionReusableView
        
        if let user = self.user {
            headerViewCell.user = user
        }
        collectionView.isScrollEnabled = false
        
        headerViewCell.delegate = self
//        headerViewCell.postCountLabel.text = "\(self.countpost.count)"
//        print("post:::\(self.countpost.count)")
//        headerViewCell.followersCountLabel.text = "\(self.countuser.count)"
        
        return headerViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        openImageStoryboard(position: indexPath.row)
    }
    
    func openImageStoryboard(position: Int) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc         =  storyboard.instantiateViewController(withIdentifier: "imagezoom") as! ImageZoom
        vc.imageUrl    =   posts[position].photoURL ?? "empty"
        vc.deleteId    =   posts[position].id
        vc.delegate    = self
        vc.showDeleteIcon = false
        present(vc, animated: true, completion: nil)
    }
    
}


extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3 - 1, height: collectionView.frame.size.width/3 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension ProfileViewController : ProfileHeaderCollectionReusableViewDelegate {
    
    func upload() {
        
        popAlert()
        
    }
    
    func editname() {
        
        
        let alert = UIAlertController(title: "Change username", message: "Enter your username", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:handleCancel))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler:{ (UIAlertAction) in
            
            if let email = self.tField.text {
                if email.count > 0 {
                    ProgressHUD.show("Updating...", interaction: true)
                    API.User.setUserProfileName(profilename: email, onSuccess: {
                        
                        ProgressHUD.showSuccess("Saved successfully.")
                        self.fetchUser()
                        
                    })
                }else {
                    ProgressHUD.showError("Username cannot be empty")

                }
                
            } else {
                
                ProgressHUD.showError("Enter username")
            }
            
            
            
        }))
        
        self.present(alert, animated: true, completion: {
            
            print("completion block")
            
        })
        
    }
    
    func configurationTextField(_ textField: UITextField!)
    {
        
        textField.placeholder = "Enter username"
        textField.inputAssistantItem.leadingBarButtonGroups.removeAll()
        textField.inputAssistantItem.trailingBarButtonGroups.removeAll()
        textField.text = PrefsManager.sharedinstance.username
        tField = textField
    }
    
    func handleCancel(_ alertView: UIAlertAction!)
    {
        print("Cancelled !!")
    }
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedProfilePhoto = self.imageOrientation(image)
            // show the progress to the user
            ProgressHUD.show("Uploading...", interaction: true)
            
            // convert selected image to JPEG Data format to push to file store
            if let profileImage = self.selectedProfilePhoto, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
                API.User.UploadImage(imageData: imageData, onSuccess:{
                    
                    ProgressHUD.showSuccess("Uploaded successfully.")
                    self.fetchUser()
                })
            }
        }
        
        dismiss(animated: true)
    }
    
    func popAlert() {
        let alert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default){ action in
            
            if(UIImagePickerController .isSourceTypeAvailable(.camera))
            {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true)
            }
            
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        // Add the actions
       
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ProfileViewController : ImageZoomDelegate {
    
    func deleteImage() {
        
        ProgressHUD.showSuccess("Deleted successfully.")
        fetchMyPosts(completion: { status in
            
            self.collectionView.reloadData()
            
            if let delegateexits = self.delegate {
                
                delegateexits.refreshPostData()
            }
            
//            self.fetchPostCount(completion: { status in
//
//                self.fetchUserCount()
//
//
//
//            })
            
        })
    }
    
    func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImageOrientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2))
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch src.imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch src.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
}



