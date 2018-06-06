//
//  HomeTableViewCell.swift
//  Blocstagram
//
//  Created by ddenis on 1/17/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import SDWebImage
import Nuke


protocol HomeTableViewCellDelegate {
    func openUserStoryboard(position : Int)
    func openImageStoryboard(position : Int)
    func deletePost(position : Int)
}
class HomeTableViewCell: UITableViewCell,SDWebImageManagerDelegate {

    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var productRatingLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    var delegate : HomeTableViewCellDelegate?
    var homeVC: HomeViewController?
    var userVC: UserViewController?
    var postReference: DatabaseReference!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var user: Users? {
        didSet {
            updateUserInfo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = ""
        captionLabel.text = ""
        
        // add a tap gesture to the comment image for users to segue to the commentVC
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCommentImageViewTap))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
        
        // add a tap gesture to the like image for users to like a post
        let likeTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLikeTap))
        likeImageView.addGestureRecognizer(likeTapGesture)
        likeImageView.isUserInteractionEnabled = true
        
        let userImagetap = UITapGestureRecognizer(target: self, action: #selector(HomeTableViewCell.profileImagetap(sender:)))
        profileImageView.addGestureRecognizer(userImagetap)
        profileImageView.isUserInteractionEnabled = true
        
        let userNametap = UITapGestureRecognizer(target: self, action: #selector(HomeTableViewCell.profileImagetap(sender:)))
        nameLabel.addGestureRecognizer(userNametap)
        nameLabel.isUserInteractionEnabled = true
        
        let postImagetap = UITapGestureRecognizer(target: self, action: #selector(HomeTableViewCell.postImagetap(sender:)))
        postImageView.addGestureRecognizer(postImagetap)
        postImageView.isUserInteractionEnabled = true
        
        let deleteImagetap = UITapGestureRecognizer(target: self, action: #selector(HomeTableViewCell.deleteImagetap(sender:)))
        shareImageView.addGestureRecognizer(deleteImagetap)
        shareImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @objc func profileImagetap(sender : UITapGestureRecognizer) {
        
        if let _ = homeVC {
            
            delegate?.openUserStoryboard(position: (sender.view?.tag)!)
            
        }

    }
    
    
    
    @objc func postImagetap(sender : UITapGestureRecognizer) {
        
        if let _ = homeVC {
            
            delegate?.openImageStoryboard(position: (sender.view?.tag)!)
            
        } else if let _ = userVC {
            
            delegate?.openImageStoryboard(position: (sender.view?.tag)!)
            
        }
        
    }
    
    @objc func deleteImagetap(sender : UITapGestureRecognizer) {
        
        if let _ = homeVC {
            
            delegate?.deletePost(position: (sender.view?.tag)!)
            
        } else if let _ = userVC {
            
            delegate?.deletePost(position: (sender.view?.tag)!)
            
        }
        
    }
    
    
    func updateView() {
        captionLabel.text = post?.caption
        let photoURL = post?.photoURL
//        if let photoURL = post?.photoURL {
//            postImageView.image = nil
            if photoURL != "" {

                Manager.shared.loadImage(with: URL(string : photoURL!)!, into: self.postImageView)
                locationName.isHidden = true
            
            } else {
                postImageView.isHidden = true
                locationName.isHidden = false
                let bounds = UIScreen.main.bounds
                let height = bounds.size.height
                
                switch height {
                case 480.0:
                    print("iPhone 3,4")
                    locationName.frame = CGRect(x: 10, y: 98, width: 296, height: 21)

                case 568.0:
                    print("iPhone 5")
                    locationName.frame = CGRect(x: 10, y: 98, width: 296, height: 21)

                case 667.0:
                    print("iPhone 6")
                    locationName.frame = CGRect(x: 10, y: 110, width: 296, height: 21)
                case 736.0:
                    print("iPhone 6+")
                    locationName.frame = CGRect(x: 10, y: 150, width: 296, height: 21)

                default:
                    print("not an iPhone")
                    
                }
                
            }
//        }
        
        self.updateLike(post: post!)
        self.ratingPost(post: post!)
        self.timePost(post: post!)
        self.locationName(post: post!)
//        self.elapsedTime(post: post!, datetime: postTime)
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        if currentUser.uid == post?.uid {
            
//            if let Driver_name = document.data()["Driver_name"] as? String {
//                print("Driver_name:::::\(String(describing: Driver_name))")
//                self.Driver_name = Driver_name
//
//            }
            nameLabel.text = PrefsManager.sharedinstance.username
            
            if profileImageView.image != nil {
//            profileImageView.image = nil
            Manager.shared.loadImage(with: URL(string : PrefsManager.sharedinstance.imageURL)!, into: self.profileImageView)
            }
        } else {
            
           
            nameLabel.text = post?.userName
            profileImageView.image = nil
            if let photoURL = post?.profileImageURL {
                print("photourl:::\(photoURL)")
                
                if photoURL != "" {
                Manager.shared.loadImage(with: URL(string : photoURL)!, into: self.profileImageView)
                
                return
                }
            }
        }
        
        
        
        
        
        
//        // get the latest post
////        API.Post.REF_POSTS.child(post!.id!).observeSingleEvent(of: .value, with: { postSnapshot in
////            if let postDictionary = postSnapshot.value as? [String:Any] {
////                let post = Post.transformPost(postDictionary: postDictionary, key: postSnapshot.key)
////                self.updateLike(post: post)
////            }
////        })
//
//        API.Post.db.collection("posts").document(post!.id!)
//            .getDocument { (document, error) in
//                if let document = document {
//                    print("Document data: \(document.data())")
//                     let post = Post.transformPost(postDictionary: document.data(), key: document.documentID)
//                     self.updateLike(post: post)
//                } else {
//                    print("Document does not exist")
//                }
//        }
//
//
//        // observe like field to update if others like this post
////        API.Post.REF_POSTS.child(post!.id!).observe(.childChanged, with: { snapshot in
////            if let value = snapshot.value as? Int {
////                self.likeCountButton.setTitle("\(value) Likes", for: .normal)
////            }
////        })
//
//        API.Post.db.collection("posts").document(post!.id!)
//            .addSnapshotListener { documentSnapshot, error in
//                guard let snapshot = documentSnapshot else {
//                    print("Error fetching snapshots: \(error!)")
//                    return
//                }
//
//            let post = Post.transformPost(postDictionary: snapshot.data(), key: snapshot.documentID)
//            self.likeCountButton.setTitle("\(post.likeCount ?? 0) Likes", for: .normal)
//
//        }

        
       
    }
    
    // flush the user profile image before a reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "profile")
    }
    
    // fetch the values from the user variable
    func updateUserInfo() {
        nameLabel.text = user?.username
        if let photoURL = user?.profileImageURL {
            profileImageView.sd_setImage(with: URL(string: photoURL), placeholderImage: UIImage(named: "profile"))
        }
    }
    
    
    // MARK: - Comment ImageView Segue
    
    @objc func handleCommentImageViewTap() {
        if let id = post?.id {
            
            if let vc = homeVC {
                
                vc.performSegue(withIdentifier: "CommentSegue", sender: id)
                
            } else if let vc = userVC {
                
                vc.performSegue(withIdentifier: "CommentSegue2", sender: id)
                
            }
            
            
        }
    }
    
    
    // MARK: - Like Tap Handler
    
    @objc func handleLikeTap() {
       
        postReference = API.Post.REF_POSTS.child(post!.id!)
        incrementLikesTrans(forReference: postReference)
        
    }
    
    func incrementLikes(forReference ref: DatabaseReference) {
        
        API.Post.db.collection("posts").document(post!.id!)
            .getDocument { (document, error) in
                if let document = document {
                    print("Document data: \(document.data())")
                    let post = Post.transformPost(postDictionary: document.data()!, key: document.documentID)
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        
                        var likes: Dictionary<String, Bool>
                        likes = post.likes  ?? [:]
                        var likeCount = post.likeCount ?? 0
                        if let isLiked = likes[uid] {
                            // Unlike the post and remove self from stars
                            
                            if isLiked {
                               
                                likeCount -= 1
                                likes[uid] = false
                                
                            } else {
                                
                                likeCount += 1
                                likes[uid] = true
                                
                            }
                          
                        }
                        
                        post.likeCount = likeCount
                        post.likes     = likes
                        post.isLiked   = likes[uid]
                        let Ref = API.Post.db.collection("posts").document(post.id!)
                        
                        // Set the "capital" field of the city 'DC'
                        Ref.updateData([
                            "likeCount": likeCount,
                            "likes.\(uid)" : likes[uid] ?? false
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                                self.updateLike(post: post)
                            }
                        }
                        
                    }
                } else {
                    print("Document does not exist")
                }
        }
    }
    
    func incrementLikesTrans(forReference ref: DatabaseReference) {
        
        
        let sfReference = API.Post.db.collection("posts").document(post!.id!)
        var postItem = Post()
        
        API.Post.db.runTransaction({ (transaction, errorPointer) -> Any? in
            let sfDocument: DocumentSnapshot
            do {
                try sfDocument = transaction.getDocument(sfReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
//            guard let _ = sfDocument.data()["likecount"] as? Int else {
//                let error = NSError(
//                    domain: "AppErrorDomain",
//                    code: -1,
//                    userInfo: [
//                        NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
//                    ]
//                )
//                errorPointer?.pointee = error
//                return nil
//            }
            
            postItem = Post.transformPost(postDictionary: sfDocument.data()!, key: sfDocument.documentID)
            
            if let uid = Auth.auth().currentUser?.uid {
                
                var likes: Dictionary<String, Bool>
                likes = postItem.likes  ?? [:]
                var likeCount = postItem.likeCount ?? 0
                if let isLiked = likes[uid] {
                    // Unlike the post and remove self from stars
                    
                    if isLiked {
                        
                        likeCount -= 1
                        likes[uid] = false
                        
                    } else {
                        
                        likeCount += 1
                        likes[uid] = true
                        
                    }
                    
                } else {
                    
                    likeCount += 1
                    likes[uid] = true
                }
                
                postItem.likeCount = likeCount
                postItem.likes     = likes
                postItem.isLiked   = likes[uid]
                
                self.updateLike(post: postItem)
            
                transaction.updateData(["likeCount": likeCount,
                                         "likes.\(uid)" : likes[uid] ?? false], forDocument: sfReference)
                
                
            }
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
                
                
            }
        }
    }
    
    func updateLike(post: Post) {
        
        DispatchQueue.main.async {
            
            let imageName = post.isLiked ?? false ? "likeSelected" : "like"
            self.likeImageView.image = UIImage(named: imageName)
            
            // display a message for Likes
            guard let count = post.likeCount else {
                return
            }
            
            if count != 0 {
                self.likeCountButton.setTitle("\(count) ", for: .normal)
            } else if post.likeCount == 0 {
                self.likeCountButton.setTitle("", for: .normal)
            }
        }
         
        
    }
    
    func ratingPost(post: Post) {
        guard let count = post.rating else {
            return
        }
        self.productRatingLabel.text = "- has rated \(count)/10 for this product."
    }
    
    func locationName(post: Post) {
        guard let count = post.location else {
            return
        }
        if locationName.text != "null" || locationName.text != ""   {
        self.locationName.text = "\(count) "
        
        }
    }
    
    func timePost(post: Post) {
      

//        guard let count = post.postTime else {
//            return
//        }
        
     
        //just to create a date that is before the current time
        
        let before = Date(timeIntervalSince1970: Double(post.postTime!))
        
                //getting the current time
                let now = Date()
        
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .full
                formatter.zeroFormattingBehavior = .dropAll
                formatter.maximumUnitCount = 1 //increase it if you want more precision
                formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
                formatter.includesApproximationPhrase = false //to write "About" at the beginning
        
        
                let formatString = NSLocalizedString("%@", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
                let timeString = formatter.string(from: before, to: now)
        
        
        
        
        self.postTime.text = timeString
    }
    
    
    
}
extension Date {
    func yearsFromNow(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    func monthsFromNow(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    func weeksFromNow(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    func daysFromNow(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    func hoursFromNow(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    func minutesFromNow(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    func secondsFromNow(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    
    func relativeTime(from date: Date) -> String {
        if yearsFromNow(from: date)   > 0 { return "\(yearsFromNow) year"    + (yearsFromNow(from: date)    > 1 ? "s" : "") + " ago" }
        if monthsFromNow(from: date)  > 0 { return "\(monthsFromNow) month"  + (monthsFromNow(from: date)   > 1 ? "s" : "") + " ago" }
        if weeksFromNow(from: date)   > 0 { return "\(weeksFromNow) week"    + (weeksFromNow(from: date)    > 1 ? "s" : "") + " ago" }
        if daysFromNow(from: date)    > 0 { return daysFromNow(from: date) == 1 ? "Yesterday" : "\(daysFromNow) days ago" }
        if hoursFromNow(from: date)   > 0 { return "\(hoursFromNow) hour"     + (hoursFromNow(from: date)   > 1 ? "s" : "") + " ago" }
        if minutesFromNow(from: date) > 0 { return "\(minutesFromNow) minute" + (minutesFromNow(from: date) > 1 ? "s" : "") + " ago" }
        if secondsFromNow(from: date) > 0 { return secondsFromNow(from: date) < 15 ? "Just now"
            : "\(secondsFromNow) second" + (secondsFromNow(from: date) > 1 ? "s" : "") + " ago" }
        return ""
    }
}
