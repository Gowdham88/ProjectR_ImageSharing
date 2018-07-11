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
import UserNotifications
import Alamofire
import SwiftyJSON


protocol HomeTableViewCellDelegate {
    func openUserStoryboard(position : Int)
    func openImageStoryboard(position : Int)
    func deletePost(position : Int)
}
class HomeTableViewCell: UITableViewCell,SDWebImageManagerDelegate {

    @IBOutlet weak var buyProduct: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
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
    @IBOutlet weak var commentCountLabel: UILabel!

    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var shareCountButton: UIButton!
    
    var delegate : HomeTableViewCellDelegate?
    var homeVC: HomeViewController?
    var userVC: UserViewController?
    var postReference: DatabaseReference!
    var commentCount = [Comment]()
    var userss = [Users]()
    var currentuser = [UserAPI]()
    var currentName: String! = ""
    var postUSerName: String! = ""
    var productbuyURL: String! = ""
    var postToken: String! = ""
//    var postItem = Post()
    var currentUserUID: String! = ""
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
    
    override func layoutSubviews() {
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 5, 0))
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        
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
        
        let buyImagetap = UITapGestureRecognizer(target: self, action: #selector(HomeTableViewCell.BuyImagetap(sender:)))
        buyProduct.addGestureRecognizer(buyImagetap)
        buyProduct.isUserInteractionEnabled = true
        
//        buyProduct
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @objc func profileImagetap(sender : UITapGestureRecognizer) {
        
        if let _ = homeVC {
            
            print("Step1 :::: home profile user image tapped")
            
//            delegate?.openUserStoryboard(position: (sender.view?.tag)!) commented by karthik
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
    
    @objc func BuyImagetap(sender: UITapGestureRecognizer) {

        if productbuyURL != nil {

        if let url = URL(string: productbuyURL) {

            UIApplication.shared.open(url, options: [:])

            }

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
        

        let photoURL = post?.photoURL
//        if let photoURL = post?.photoURL {
//            postImageView.image = nil
        if photoURL != "" {
            if photoURL != nil {
                Manager.shared.loadImage(with: URL(string : photoURL!)!, into: self.postImageView)
            }
            if locationName != nil {
                locationName.isHidden = true
            }
            } else {
            if locationName != nil {
                postImageView.isHidden = true
            
                locationName.isHidden = false
                let bounds = UIScreen.main.bounds
                let height = bounds.size.height
                
                switch height {
                case 480.0:
                    print("iPhone 3,4")

                case 568.0:
                    print("iPhone 5")
                    locationName.frame = CGRect(x: 10, y: 90, width: 296, height: 21)

                case 667.0:
                    print("iPhone 6")
                    locationName.frame = CGRect(x: 10, y: 100, width: 296, height: 21)

                case 736.0:
                    print("iPhone 6+")
                    locationName.frame = CGRect(x: 10, y: 105, width: 296, height: 21)
                case 812.0:
                    print("iPhone X")
                    locationName.frame = CGRect(x: 20, y: 105, width: 296, height: 21)

                default:
                    print("not an iPhone")
                    
                }
            }
        }
//        }
        
        self.updateLike(post: post!)
        self.ratingPost(post: post!)
        self.timePost(post: post!)
        self.locationName(post: post!)
        self.productnamepost(post: post!)
        self.productUrl(post: post!)
        self.caption(post: post!)
        self.tokenPost(post: post!)
        
//        self.elapsedTime(post: post!, datetime: postTime)
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        if currentUser.uid == post?.uid {

            nameLabel.text = post?.userName
         
            if profileImageView.image != nil {
                
                if  (post?.profileImageURL?.count)! > 2 {
                    
                    Manager.shared.loadImage(with: URL(string : (post?.profileImageURL)!)!, into: self.profileImageView)
                    
                }
               
                
            }
        } else {
            
           
            nameLabel.text = post?.userName
            print("namelabel::::\(nameLabel.text)")
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
        
//        let content = UNMutableNotificationContent()
//        content.title = "You have a notification"
//        content.subtitle = "the post have a like"
//        content.badge = 1
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
       
        postReference = API.Post.REF_POSTS.child(post!.id!)
        incrementLikesTrans(forReference: postReference)
        
        
    }
    
    func incrementLikes(forReference ref: DatabaseReference) {
        API.User.observeCurrentUser(completion: { (user) in
            if self.currentName != nil {
                
                self.currentName = user.username!
                
                print("currentname::\(String(describing: self.currentName))")
                
            }
        })
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
        API.User.observeCurrentUser(completion: { (user) in
            if self.currentName != nil {
                
                self.currentName = user.username!
               
                print("currentname::\(String(describing: self.currentName))")
                
            }
            
            if self.currentUserUID != nil {
                
                 self.currentUserUID = user.uid!
                 print("currentUserUID::\(String(describing: self.currentUserUID))")
            }
        })
        
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
//                    self.postNotification(postItem: postItem.documentID!, post: self.post!)

                }
                
                postItem.likeCount = likeCount
                postItem.likes     = likes
                postItem.isLiked   = likes[uid]
                
                self.updateLike(post: postItem)
            
                transaction.updateData(["likeCount": likeCount,
                                         "likes.\(uid)" : likes[uid] ?? false], forDocument: sfReference)
                
//              postNotification(postItem: postItem, post: post!)
                
//                self.postNotification(postItem: postItem.documentID!, post: self.post!)
                if self.currentUserUID != postItem.uid {

                    self.postNotification(postItem: postItem.documentID!, post: self.post!)

                    print("Different user uid")


                } else {


                    print("current user uid")
                    print("currentUserUID")


                }
                
            }
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
                 let db = Firestore.firestore()
                if self.postUSerName != nil {
                 self.postUSerName = self.post!.userName
                   
                 print("postUSerName::\(String(describing: self.postUSerName))")
                }
                print("currentusernamesss:::\(self.currentName)")
                let finalcomment = self.currentName + " " + "likes" + " " + self.postUSerName
                print("finalcomment::::\(finalcomment)")
               
                db.collection("activity").document().setData([
                    "uid": self.post?.uid ?? "empty",
                    "currentUserUID": API.User.CURRENT_USER?.uid ?? "empty",
                    "currentUserName": self.currentName ?? "empty",
                    "activityName": finalcomment + " " + "product." ,
                    "userName"  : self.postUSerName ?? "empty"

                    ]){ err in
                        if let err = err {
                            print("Error writing document: \(err)")
                            ProgressHUD.showError("Error : \(err.localizedDescription)")
                        } else {
                            
                            print("Document successfully committed!")
                        }
                }
             
            }
        }
    }
    
    func updateLike(post: Post) {
        
        DispatchQueue.main.async {
            
            let imageName = post.isLiked ?? false ? "firecolors" : "fireuncolors"
            self.likeImageView.image = UIImage(named: imageName)

            
            // display a message for Likes
            guard let count = post.likeCount else {
                return
            }
            
            if count != 0 {
                self.likeCountButton.setTitle("\(count) Dope", for: .normal)
            } else if post.likeCount == 0 {
                self.likeCountButton.setTitle("0 Dope", for: .normal)
            }
        }
         
        
    }
    
    func ratingPost(post: Post) {
        guard let count = post.rating else {
            return
        }
        if productRatingLabel != nil {
        self.productRatingLabel.text = "- has rated \(count)/10 for this product."
            print("selfrating:::\(self.productRatingLabel.text)")
        }
    }
    
    func tokenPost(post: Post) {
//        guard let count = post.token else {
//            return
//        }
     
        if postToken != nil{
        postToken = post.token
            print("posttoken::::\(postToken)")
        }
    }
    
    func postNotification(postItem: String, post: Post) {
        
        
//                declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid

       
        
        print("Get token from post:::",post.token)
        print(postItem)
        let token = UserDefaults.standard.string(forKey: "token")
                //create the url with URL
        
        
        var parameters       = [String:Any]()
        
        parameters["count"]  = post.likeCount!
        parameters["likedby"]  = currentName
        parameters["postId"] = postItem
        parameters["token"] = post.token!
        
   
        
        
        let headers: HTTPHeaders = ["Content-Type" :"application/x-www-form-urlencoded"]
        
        
        
        
        let RequestData = NSMutableURLRequest(url: NSURL.init(string: "http://highavenue.co:9000/likesnotification/")! as URL)
        RequestData.httpMethod = "POST"
        RequestData.timeoutInterval = 250 // Time interval here.
        
        Alamofire.request(RequestData as! URLRequestConvertible).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) { // response
                print(responseData.result.value!)
            }
        }

//        Alamofire.request("http://highavenue.co:9000/likesnotification", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
//                    //             original URL request
//                        print("Request is :",response.request!)
//
//                        // HTTP URL response --> header and status code
//                        print("Response received is :",response.response)
//
//                        // server data : example 267 bytes
//                        print("Response data is :",response.data)
//
//                        // result of response serialization : SUCCESS / FAILURE
//                        print("Response result is :",response.result)
//
//                        debugPrint("Debug Print :", response)
//
//
//        }
        
//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 120
//
//        manager.request("http://highavenue.co:9000/likesnotification", method: .post, parameters: parameters)
//            .responseJSON {
//                response in
//                switch (response.result) {
//                case .success:
//                    //do json stuff
//                    break
//                case .failure(let error):
//                    if error._code == NSURLErrorTimedOut {
//                        //HANDLE TIMEOUT HERE
//
//                    }
//                    print("\n\nAuth request failed with error:\n \(error)")
//                    break
//                }
//        }
        
//        Alamofire.request(request, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//
//            // original URL request
//            print("Request is :",response.request!)
//
//            // HTTP URL response --> header and status code
//            print("Response received is :",response.response)
//
//            // server data : example 267 bytes
//            print("Response data is :",response.data)
//
//            // result of response serialization : SUCCESS / FAILURE
//            print("Response result is :",response.result)
//
//            debugPrint("Debug Print :", response)
//        }
//
     
        
    }

    
    func productnamepost(post: Post) {
        
        guard let count = post.productName else {
            return
        }
        if productNameLabel !=  nil {
            
            self.productNameLabel.text = "\(count)"
            print("selfproductname:::\(self.productNameLabel.text)")
        }
       
        
    }
    
    func productUrl(post: Post) {
        guard let count = post.productDetailPageURL else {
            return
        }
        if productbuyURL != nil {
            
            productbuyURL = "\(count)"
            print("selfproductbuyURL:::\(self.productbuyURL)")
        }
    }
    
    func caption(post: Post) {
        guard let count = post.caption else {
            return
        }
        if captionLabel != nil {
            
            captionLabel.text = "\(count)"
            print("selfcaptionLabel:::\(self.captionLabel.text)")
        }
    }
    
    func locationName(post: Post) {
        guard let count = post.location else {
            return
        }
        if locationName != nil {
        
        if locationName.text != "null" || locationName.text != ""   {
        self.locationName.text = "\(count) "
            }
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
        
        
        if postTime != nil {
        
        self.postTime.text = timeString
            print("Get time:::::",timeString)
   
        }
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
    
    //
    func relativeTime(from date: Date) -> String {
        if yearsFromNow(from: date)   > 0 { return "\(yearsFromNow) year"    + (yearsFromNow(from: date)    > 1 ? "s" : "") + " ago" }
        if monthsFromNow(from: date)  > 0 { return "\(monthsFromNow) month"  + (monthsFromNow(from: date)   > 1 ? "s" : "") + " ago" }
        if weeksFromNow(from: date)   > 0 { return "\(weeksFromNow) week"    + (weeksFromNow(from: date)    > 1 ? "s" : "") + " ago" }
        if daysFromNow(from: date)    > 0 { return daysFromNow(from: date) == 1 ? "Yesterday" : "\(daysFromNow) days ago" }
        if hoursFromNow(from: date)   > 0 { return "\(hoursFromNow) hour"     + (hoursFromNow(from: date)   > 1 ? "s" : "") + " ago" }
        if minutesFromNow(from: date) > 0 { return "\(minutesFromNow) min" + (minutesFromNow(from: date) > 1 ? "s" : "") + " ago" }
        if secondsFromNow(from: date) > 0 { return secondsFromNow(from: date) < 15 ? "Just now"
            : "\(secondsFromNow) second" + (secondsFromNow(from: date) > 1 ? "s" : "") + " ago" }
        return ""
    }
}
extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
