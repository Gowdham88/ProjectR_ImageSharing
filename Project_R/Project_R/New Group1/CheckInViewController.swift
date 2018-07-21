//
//  CheckInViewController.swift
//  Project_R
//
//  Created by CZSM2 on 05/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth
import MapKit
import GooglePlaces
import Alamofire
import SwiftyJSON
import AWSCore

class CheckInViewController: UIViewController, UITextViewDelegate, UISearchBarDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var tableViews: UIView!
    @IBOutlet weak var searchLoaction: UITextField!
    @IBOutlet weak var addCaptionLabel: UILabel!
    @IBOutlet weak var sliderValue: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var rateproduct: UILabel!
    @IBOutlet weak var addProductLabe: UILabel!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var clearBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarBtn: UIBarButtonItem!
    @IBOutlet weak var locationSearchTable: UITableView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    let imagePicker = UIImagePickerController()
    var delegate  : CameraViewControllerDelegate?
    var ratingValue: String?
    var autocompleteplaceArray = [String]()
    var locationText: String?
    var selectedImage: UIImage?
    var imageUrlVc: String?
    var likeHoodList: GMSPlaceLikelihoodList?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.layer.cornerRadius = 20
        photoImageView.layer.shadowColor = UIColor.black.cgColor
        photoImageView.layer.shadowOpacity = 0.2
        photoImageView.layer.shadowOffset = CGSize(width: -1, height: 1)
        photoImageView.layer.shadowRadius = 4
        photoImageView.layer.masksToBounds = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPop))
        photoImageView.addGestureRecognizer(tapGesture)
        photoImageView.isUserInteractionEnabled = true
        photoImageView.layer.cornerRadius = 2
        API.Post.Recuringpoststop()
        
        captionTextView.returnKeyType = UIReturnKeyType.done
        
        //Dismiss keyboard - touch any where
        self.hideKeyboardWhenTappedAround()
        
        //Navigation bar title color
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        self.captionTextView.delegate = self
        self.captionTextView.layer.cornerRadius = 5
        
        //searchLocation bar design changes
        self.searchLoaction.text = ""
        self.searchLoaction.delegate = self
        self.searchLoaction.layer.cornerRadius = 3.0
        self.searchLoaction.clipsToBounds = true
        
        captionTextView.layer.shadowColor = UIColor.black.cgColor
        captionTextView.layer.shadowOpacity = 0.2
        captionTextView.layer.shadowOffset = CGSize.zero
        captionTextView.layer.shadowRadius = 4
        captionTextView.layer.masksToBounds = false
        captionTextView.textContainer.maximumNumberOfLines = 4
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPop))
//        photoImageView.addGestureRecognizer(tapGesture)
//        photoImageView.isUserInteractionEnabled = true
//        photoImageView.layer.cornerRadius = 2
        API.Post.Recuringpoststop()
        
        tabBarController?.tabBar.isHidden = true
        /*********FILTER VIEW*********/
        tableViews.isHidden = true
//        locationSearchTable.isHidden = true
        locationSearchTable.delegate   = self
        locationSearchTable.dataSource = self
        
        
        //Bar button - font size
        cancelBarBtn.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Avenir Light", size: 16)!,], for: .normal)
        clearBarButton.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Avenir Light", size: 16)!,], for: .normal)
        
//        if let address =  PrefsManager.sharedinstance.lastlocation {
//
//            searchLoaction.text = address
//
//        }
        shareButton.layer.cornerRadius = 15
    }
    
    @IBAction func CancelPost(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
//        setButtons()
        
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
    

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    

    @IBAction func clearInputs() {
        // clear photo, selected image and caption text after saving
        self.view.endEditing(true)
        self.captionTextView.text = "Write something here"
//        setButtons()
    }

    
    
    @IBAction func share(_ sender: Any) {
        // show the progress to the user
//        ProgressHUD.show("Sharing started...", interaction: false)

         sharePost()

    }
    
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
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    
    func saveToDatabase(photoURL: String) {
        let ref = Database.database().reference()
        let postsReference = ref.child("post")
        let newPostID = postsReference.childByAutoId().key
        
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let likes   = [currentUserID : false]
        
        var users : Users!
        
        API.User.observeCurrentUser { user in
            users = user
            let db = Firestore.firestore()
            db.collection("posts").document(newPostID).setData([
                "uid": currentUserID,
//                "photoURL": "https://firebasestorage.googleapis.com/v0/b/project-r-7ed28.appspot.com/o/placeholder.png?alt=media&token=02c65040-9371-44e3-ac80-f272032ea6bc",
                "photoURL": photoURL,
                "caption": self.captionTextView.text!,
                "likeCount" : 0,
                "userName"  : users.username ?? "empty",
                "profileImageURL" : users.profileImageURL ?? "empty",
                "postTime"        : Date().timeIntervalSince1970,
                "likes"           : likes,
                "documentID": newPostID,
                "rating": self.ratingValue ?? "empty",
                "location": self.locationText ?? "empty"
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                    ProgressHUD.showError("Photo Save Error: \(err.localizedDescription)")
                } else {
                    print("Document successfully written!")
                    
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
                    
//                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
//                    let vc         =  storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
//
                    self.clearInputs()
                    // and jump to the Home tab
                    
                    if let delegateexits = self.delegate {
                        
                        delegateexits.saveData()
                    }
                    
                    self.tabBarController?.selectedIndex = 0
                }
            }
            
        }
        
    navigationController?.popViewController(animated: true)
    
}

    
}

extension CheckInViewController: UINavigationControllerDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Write something here" {
            
            textView.text = ""
            
        }
     }
}

extension CheckInViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let searchPlaces = GMSAutocompleteViewController()
        searchPlaces.delegate = self
        self.present(searchPlaces, animated: true, completion: nil)

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

       
        
        if textField == searchLoaction  {
            
            if searchLoaction.text != "" {
                
//                setNavBar()
            }
            
            
        }
        
        
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
//            self.locationSearchTable.isHidden = true
            self.tableViews.isHidden = true
            self.locationSearchTable.transform = top
        }, completion: nil)
//        dismissKeyboard()
        
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
//            self.locationSearchTable.isHidden = true
            self.tableViews.isHidden = true

        }, completion: nil)
        
//        dismissKeyboard()
        
        if textField == searchLoaction {
            
            searchLoaction.text = ""
            
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if searchLoaction.text != "" {
//            LoadingHepler.instance.show()
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
//                LoadingHepler.instance.hide()
            }
            
        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchLoaction {
            if let place = textField.text {
                
                getPlaceApi(place_Str: "\(place)\(string)" as String)
                
                let top = CGAffineTransform(translationX: 0, y: 0)
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
//                    self.locationSearchTable.isHidden = false
                    self.tableViews.isHidden = false

                    self.locationSearchTable.transform = top
                }, completion: nil)
                //                dismissKeyboard()
                
            }
        }
        
        
        return true
    }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
            captionTextView.resignFirstResponder()
            searchLoaction.resignFirstResponder()
    
        }
}
extension CheckInViewController : GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        
        searchLoaction.text = place.name
        
        
        if let placeName = place.formattedAddress {
            
            print("Place address: \(placeName)")
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
}


extension CheckInViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return autocompleteplaceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "placecell", for: indexPath) as! locationNameTableViewCell
        
        guard autocompleteplaceArray.count > 0 else {
            
            return cell
        }
        
       
        cell.locationNames.text = autocompleteplaceArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1  {
            
            tableView.allowsSelection = true
            
        } else {
            
            tableView.allowsSelection = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let indexPath = tableView.indexPathForSelectedRow  {
            let currentCell = tableView.cellForRow(at: indexPath)
            searchLoaction.text = (currentCell?.textLabel?.text)
            searchLoaction.text = autocompleteplaceArray[indexPath.row]
            PrefsManager.sharedinstance.lastlocation = searchLoaction.text
            locationText = searchLoaction.text
            
            print("locationText::::\(String(describing: locationText))")
        }
        
//        dismissKeyboard()
        
//        let top = CGAffineTransform(translationX: 0, y: -self.locationSearchTable.frame.height)
//        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
//            self.locationSearchTable.transform = top
//        }, completion: nil)
        
        self.tableViews.isHidden = true
        
    }
    
    func sharePost(){
       
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
                self.imageUrlVc = photoURL
                
                // and put the photoURL into the database
                self.saveToDatabase(photoURL: photoURL!)
               
            })
        } else {
            ProgressHUD.showError("Your photo to Share can not be empty. Tap it to set it and Share.")
        }
    }
    
    func getPlaceApi(place_Str:String) {
        
        autocompleteplaceArray.removeAll()
        
//        let parameters: Parameters = ["input": place_Str ,"types" : "(cities)" , "key" : "AIzaSyDmfYE1gIA6UfjrmOUkflK9kw0nLZf0nYw"]
        let parameters: Parameters = ["input": place_Str ,"types" : "(sublocality)" , "key" : "AIzaSyDmfYE1gIA6UfjrmOUkflK9kw0nLZf0nYw"]
        
        print("Get search location value",parameters)
        
        Alamofire.request(Constants.PlaceApiUrl, parameters: parameters).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if let status = json["status"].string {
                        print(status)
                        if let place_dic = json["predictions"].array {
                            
                            for item in place_dic {
                                
                                let placeName = item["description"].string ?? "empty"
                                if self.autocompleteplaceArray.count < 6 {
                                    
                                    self.autocompleteplaceArray.append(placeName)
                                }
                                
                                
                            }
                            
                            DispatchQueue.main.async {
                                
                                self.locationSearchTable.reloadData()
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            case .failure(let error):
                print(error)
                
                DispatchQueue.main.async {
                    
                    self.locationSearchTable.reloadData()
                    
                }
                
            }
            
        }
        
    }
    
    
}

extension CheckInViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CheckInViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CheckInViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = self.imageOrientation(image)
            selectedImage = self.imageOrientation(image)
        }
        
        dismiss(animated: true)
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




