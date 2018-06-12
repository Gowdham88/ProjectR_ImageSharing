//
//  CameraViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth

protocol CameraViewControllerDelegate {
    
    func saveData()
    
}


class CameraViewController: UIViewController,UITextViewDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addCaptionLabel: UILabel!
    @IBOutlet weak var sliderValue: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var rateproduct: UILabel!
    @IBOutlet weak var addProductLabe: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var clearBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarBtn: UIBarButtonItem!
    
    var selectedImage: UIImage?
    var delegate  : CameraViewControllerDelegate?
    var ratingValue: String?
    var dateTime: Double!
    
    
    

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dismiss keyboard - touch any where
        self.hideKeyboardWhenTappedAround()
        
        
        //Navigation bar title color
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 7/255, green: 192/255, blue: 141/255, alpha: 1)]
//        cancelBarBtn.setTitleTextAttributes([
//            NSAttributedStringKey.font : UIFont(name: "Avenir Light", size: 16)!,], for: .normal)
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.captionTextView.delegate = self
        
        //Search bar design changes
        self.searchBar.delegate = self
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.layer.cornerRadius = 3.0
        self.searchBar.clipsToBounds = true
//        self.searchBar.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        

//        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 20
        photoImageView.layer.shadowColor = UIColor.black.cgColor
        photoImageView.layer.shadowOpacity = 0.2
        photoImageView.layer.shadowOffset = CGSize(width: -1, height: 1)
        photoImageView.layer.shadowRadius = 4
        photoImageView.layer.masksToBounds = false
   
//        self.view.addSubview(photoImageView)
        
        self.captionTextView.layer.cornerRadius = 5
//      self.addProfileImageView.clipsToBounds = true
        
        captionTextView.layer.shadowColor = UIColor.black.cgColor
        captionTextView.layer.shadowOpacity = 0.2
        captionTextView.layer.shadowOffset = CGSize.zero
        captionTextView.layer.shadowRadius = 4
        captionTextView.layer.masksToBounds = false

//        self.view.addSubview(captionTextView)
        
        
        // Make the button a Rounded Rect
        shareButton.layer.cornerRadius = 15
        
        // add a tap gesture to the placeholder image for users to pick
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPop))
        photoImageView.addGestureRecognizer(tapGesture)
        photoImageView.isUserInteractionEnabled = true
        photoImageView.layer.cornerRadius = 2
        API.Post.Recuringpoststop()
        
        tabBarController?.tabBar.isHidden = true
        
        
        cancelBarBtn.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Avenir Light", size: 16)!,], for: .normal)
        
        
    }
    @IBAction func CancelPost(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
        setButtons()
       
    }
    
    @IBAction func ratingSlider(_ sender: UISlider) {
        
        
        let rating = Int(sender.value)
        
        sliderValue.text = "\(rating)"
        
        ratingValue = sliderValue.text
        print("ratingValue::::\(String(describing: ratingValue))")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
         tabBarController?.tabBar.isHidden = false
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        captionTextView.resignFirstResponder()
////        searchBar.resignFirstResponder()
//        return true
//    }
   
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//        captionTextView.resignFirstResponder()
//        searchBar.resignFirstResponder()
//
//    }
//    func dismiss(_ sender:UITapGestureRecognizer) {
//        self.view.endEditing(true)
//    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
    
 
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
        func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
          view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // MARK: - Handle the Image Selection and Button UI
    @objc func showPop(){
        
        
        let Alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let CamAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { ACTION in
            self.openCamera()
        }
        
        let GallAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default){ ACTION in
            self.handlePhotoSelection()
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
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera))
        {
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func handlePhotoSelection() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    
    // based on the image toggle the buttons
    
    func setButtons() {
        if selectedImage != nil {
            // if there is an image the buttons should be enabled
            shareButton.isEnabled = true
            shareButton.alpha = 1.0
            clearBarButton.isEnabled = true
        } else {
            // otherwise - disable the buttons
            shareButton.isEnabled = false
            shareButton.alpha = 0.2
            clearBarButton.isEnabled = false
           
        }
    }
    
    func CurrentDate(){
        
        
       
        
        
    }
    // MARK: - The Share Action
    
    @IBAction func share(_ sender: Any) {
        // show the progress to the user
        ProgressHUD.show("Sharing started...", interaction: false)
        
        // convert selected image to JPEG Data format to push to file store
        if let photo = selectedImage, let imageData = UIImageJPEGRepresentation(photo, 0.1) {
            
            // get a unique ID
            let photoIDString = NSUUID().uuidString
            
            // get a reference to our file store
            let storeRef = Storage.storage().reference(forURL: Constants.fileStoreURL).child("posts").child(photoIDString)
            
            // push to file store
            storeRef.putData(imageData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    ProgressHUD.showError("Photo Save Error: \(error?.localizedDescription)")
                    return
                }
                
                // if there's no error
                // get the URL of the photo in the file store
                let photoURL = metaData?.downloadURL()?.absoluteString
                
                // and put the photoURL into the database
                self.saveToDatabase(photoURL: photoURL!)
            
            })
        } else {
            ProgressHUD.showError("Your photo to Share can not be empty. Tap it to set it and Share.")
        }
    }
    
    
    // MARK: - Dismiss Keyboard
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
    
    
    @IBAction func clearInputs() {
        // clear photo, selected image and caption text after saving
        self.view.endEditing(true)
        self.captionTextView.text = "Write something here"
        self.photoImageView.image = UIImage(named: "placeholder-photo")
        self.selectedImage = nil
        setButtons()
    }
    
//    func elapsedTime (datetime : String) -> String
//    {
//        //just to create a date that is before the current time
//
//        let before = Date(timeIntervalSince1970: Double(datetime)!)
//
//        //getting the current time
//        let now = Date()
//
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .full
//        formatter.zeroFormattingBehavior = .dropAll
//        formatter.maximumUnitCount = 1 //increase it if you want more precision
//        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
//        formatter.includesApproximationPhrase = false //to write "About" at the beginning
//
//
//        let formatString = NSLocalizedString("%@", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
//        let timeString = formatter.string(from: before, to: now)
//        return String(format: formatString, timeString!)
//    }

    // MARK: - Save to Firebase Method
    
    func saveToDatabase(photoURL: String) {
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostID = postsReference.childByAutoId().key
      
       
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let likes   = [currentUserID : false]
       
        var users : Users!
        
    
        

        API.User.observeCurrentUser { user in
            users = user
            let db = Firestore.firestore()
            db.collection("posts").document(newPostID).setData([
                "uid": currentUserID,
                "photoURL": photoURL,
                "caption": self.captionTextView.text!,
                "likeCount" : 0,
                "userName"  : users.username ?? "empty",
                "profileImageURL" : users.profileImageURL ?? "empty",
                "postTime"        : Date().timeIntervalSince1970,
//                "postTime"          : timeOffset1,
                "likes"           : likes,
                "documentID": newPostID,
                "rating": self.ratingValue ?? "empty",
                "location": "" ?? "empty"
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                    ProgressHUD.showError("Photo Save Error: \(err.localizedDescription)")
                } else {
                    print("Document successfully written!")
                    API.Feed.REF_FEED.child(API.User.CURRENT_USER!.uid).child(newPostID).setValue(true)

                    db.collection("user-posts").document(newPostID).setData([
                        newPostID: "true",
                        
                        ]){ err in
                            if let err = err {
                                print("Error writing document: \(err)")
                                ProgressHUD.showError("Photo Save Error: \(err.localizedDescription)")
                                return
                            }
                    }
                    
                    ProgressHUD.showSuccess("Photo shared")
                    
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let vc         =  storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    self.clearInputs()
                    // and jump to the Home tab
                    
                    if let delegateexits = self.delegate {
                        
                        delegateexits.saveData()
                    }
                    
                    self.tabBarController?.selectedIndex = 0
                }
            }
            
        }
      
    }
    
   
    
}


// MARK: - ImagePicker Delegate Methods

extension CameraViewController: UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = self.imageOrientation(image)
            selectedImage = self.imageOrientation(image)
        }
        
        dismiss(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Write something here" {

            textView.text = ""

        }
       
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

extension CameraViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ captionTextView: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



