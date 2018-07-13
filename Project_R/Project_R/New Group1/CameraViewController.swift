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
import FirebaseDatabase
import AWSCore
import Alamofire
import AWSAPIGateway
import SHXMLParser
import Nuke
 
 struct getProductIndex {
  
    static var arrayProd           = [String]()
//    
//    static var index              : Int = -1
 }


protocol CameraViewControllerDelegate {
    
    func saveData()
    
}

 var postNewID: String?

class CameraViewController: UIViewController,UITextViewDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    static let kAmazonAccessID = "AKIAJ3VPWLGL2UIWB3SA"
    static let kAmazonAccessSecretKey = "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"
    
    static let kAmazonAssociateTag = "projectr0c-21"
    var searchWord: String?
    var DateString: String?
//    var timestampFormatter = DateFormatter()
    
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var tableView: UITableView!
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
    var currentName: String! = ""
    var ref:DatabaseReference?
    var getSearch = [String]()
//    AWS String
    
    var page: String = ""
    var sorting: String = ""
    var users = [User]()
    // MARK: - View Lifecycle
    
    //amazon product name search model//
    var ProductName = [amazonProductName]()
    var productTitle: String = String()
    var productDetailPageURL:String = String()
    var productASIN:String = String()
    var results = [[String: String]]()
    var indices: [String] = []
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue: String?                // the current value for one of the keys in the dictionary
    let recordKey = "Item"
    let dictionaryKeys = Set<String>(["Title"])
    let dictionaryKeys1 = Set<String>(["DetailPageURL"])
    let dictionaryKeys2 = Set<String>(["ASIN"])
    let dictionaryKeys3 = Set<String>(["URL"])
    var books: [Book] = []
    var eName: String = String()
    var bookTitle = String()
    var bookAuthor = String()
    var searchText: String?
    var poductDetailPageUrl: String?
    var AISNid:String?
    var ImageByItemId:String?
    var prodList    = [productList]()
    var imageUrlVc: String?
    var skipBool : Bool = true
    /****************/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.collection("products").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
               for (position, document) in querySnapshot!.documents.enumerated() {
                print("\(document.documentID) => \(document.data())")
                
                
                if let product = productList(dictionary: document.data()) {
//                    self.prodList.append(product)
                    
                    getProductIndex.arrayProd.append(product.productName!)
                    print("::Get product name::",getProductIndex.arrayProd)
                    
                }
                
                if position == querySnapshot!.documents.count-1 {
                    self.tableView.reloadData()
                }
                

                
                }
            }
        }

        
        if let address =  PrefsManager.sharedinstance.lastlocation {
            searchBar.text = address
          
        }
        
        captionTextView.returnKeyType = UIReturnKeyType.done

        self.extendedLayoutIncludesOpaqueBars = true
        
        //Dismiss keyboard - touch any where
        self.hideKeyboardWhenTappedAround()

        //Navigation bar title color
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
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
        captionTextView.textContainer.maximumNumberOfLines = 3
        tableView.isHidden = true

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
        
        
//        searchKeyword = searchWord
       
        
       
    }
    
    
    
   
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
       
        
        if searchBar.text == nil || searchBar.text == "" {
            
       
            let alert = UIAlertController(title: "Alert!", message: "Enter product to search", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            tableView.isHidden = true
            
        } else {
            
            
        
//           searchBar.resignFirstResponder()
        
//        if !shouldShowSearchResults {
//            shouldShowSearchResults = true
//            tblSearchResults.reloadData()
//        }
//
        
        searchWord = searchBar.text!
//        _ = itemSearch(searchKeyword: searchKeyword)
        
//        print("itemSearch::::\(itemSearch(searchKeyword: searchKeyword))")
//        searchController.searchBar.resignFirstResponder()
        
        
        self.results.removeAll()   // removes search bar prev.history from table view 
        getSearchItem(searchKeyword: searchWord!)
            
       
        searchBar.text = ""
        tableView.isHidden = false
        
        tableView.reloadData()
        }
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        tableView.reloadData()
//
//    }
    
    /*****************amazon product search*****************/
    
    private func signedParametersForParameters(parameters: [String: String]) -> [String: String] {
        let sortedKeys = Array(parameters.keys).sorted(by: <)
        
        let query = sortedKeys.map { String(format: "%@=%@", $0, parameters[$0] ?? "") }.joined(separator: "&")
        
        let stringToSign = "GET\nwebservices.amazon.in\n/onca/xml\n\(query)"
        print("stringToSign::::\(stringToSign)")
        
        let dataToSign = stringToSign.data(using: String.Encoding.utf8)
        let signature = AWSSignatureSignerUtility.hmacSign(dataToSign, withKey: CameraViewController.kAmazonAccessSecretKey, usingAlgorithm: UInt32(kCCHmacAlgSHA256))!
        
        var signedParams = parameters;
        signedParams["Signature"] = urlEncode(signature)
        print("urlencodesignature::\(urlEncode(signature))")
        
        return signedParams
    }
    
    public func urlEncode(_ input: String) -> String {
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        
        if let escapedString = input.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            return escapedString
        }
        
        return ""
    }
    func send(url: String) -> String {
//        activityIndicator.startAnimating()
        guard let url = URL(string: url) else {
            print("Error! Invalid URL!") //Do something else
//            activityIndicator.stopAnimating()
            return ""
        }
        print("send URL: \(url)")
        let request = URLRequest(url: url)
        let semaphore = DispatchSemaphore(value: 0)
        
        var data: Data? = nil
        
        URLSession.shared.dataTask(with: request) { (responseData, _, _) -> Void in
            data = responseData

            print("send URL session data: \(String(describing: data))")
            let parser = XMLParser(data: data!)
            parser.delegate = self as? XMLParserDelegate
            if parser.parse() {
                print(self.results ?? "No results")
            }
            semaphore.signal()

            }.resume()
    
//        activityIndicator.stopAnimating()
        semaphore.wait(timeout: .distantFuture)
        
        let reply = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        return reply
    }
 
    public func getSearchItem(searchKeyword: String) -> [String:AnyObject]{
        
        let timestampFormatter: DateFormatter
        timestampFormatter = DateFormatter()
        timestampFormatter.timeZone = TimeZone(identifier: "GMT")
        timestampFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss'Z'"
        timestampFormatter.locale = Locale(identifier: "en_US_POSIX")
        
//        let responsegroupitem: String = "ItemAttributes"
//        let responsegroupImages:String = "Images"
        
//        activityIndicator.startAnimating()
        let operationParams: [String: String] = [
            "Service": "AWSECommerceService",
            "Operation": "ItemSearch",
//            "ResponseGroup": "Images,ItemAttributes",
            "ResponseGroup":urlEncode("Images,ItemAttributes"),
            "IdType": "ASIN",
            "SearchIndex":"All",
            "Keywords": urlEncode(searchKeyword),
            "AWSAccessKeyId": urlEncode(CameraViewController.kAmazonAccessID),
            "AssociateTag": urlEncode(CameraViewController.kAmazonAssociateTag),
            "Timestamp": urlEncode(timestampFormatter.string(from: Date()))]
        
        let signedParams = signedParametersForParameters(parameters: operationParams)
        
        
        
        let query = signedParams.map { "\($0)=\($1)" }.joined(separator: "&")
        let url = "http://webservices.amazon.in/onca/xml?" + query
        print("querydata::::\(query)")
       
        let reply = send(url: url)
        print("reply::::\(reply)")
//        activityIndicator.stopAnimating()
        
       

        return [:]
    }
    

 
 
    
    /*******************************************************/
    
    
  


    
    @IBAction func CancelPost(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        
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
        
         tabBarController?.tabBar.isHidden = true
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
        
//
                  showBillVerification()
        
    }
    
    
    func sharePost(){
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
                self.imageUrlVc = photoURL
                
                // and put the photoURL into the database
                self.saveToDatabase(photoURL: photoURL!)
                //                self.saveActivity()
                //                self.getname()
            })
        } else {
            ProgressHUD.showError("Your photo to Share can not be empty. Tap it to set it and Share.")
        }
    }
    
    func showBillVerification(){
        
        let Alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        
        let verifyAction: UIAlertAction = UIAlertAction(title: "Do you want to verify the bill", style: .default) { ACTION in
            
            self.billVerification()
            self.sharePost()
            self.skipBool = false
//            self.sharePost()
            
        }
        
        
        
        let skipAction: UIAlertAction = UIAlertAction(title: "Skip", style: .default){ ACTION in
            
            self.sharePost()
            self.skipBool = true
        }
        
        let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        CancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        
        Alert.addAction(verifyAction)
        
        Alert.addAction(skipAction)
        
        Alert.addAction(CancelAction)
        
        present(Alert, animated: true, completion: nil)
        
    }
    
    func billVerification() {
        
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        let vc         =  storyboard.instantiateViewController(withIdentifier: "verification") as! verification
        vc.imageVc = selectedImage
//         self.imageUrlVc = photoURL
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    public func textViewDidChange(_ textView: UITextView) {
        
//            textView.resignFirstResponder() //Dismiss keyboard
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
        let token = UserDefaults.standard.string(forKey: "token")
        
        print("token::::::\(token)")

       
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let likes   = [currentUserID : false]
       
        var users : Users!
        
    
        postNewID = newPostID

        API.User.observeCurrentUser { user in
            users = user
            
            self.db.collection("posts").document(newPostID).setData([
                "uid": currentUserID,
                "photoURL": photoURL,
                "caption": self.captionTextView.text!,
                "likeCount" : 0,
                "userName"  : users.username ?? "",
                "profileImageURL" : users.profileImageURL ?? "",
                "postTime"        : Date().timeIntervalSince1970,
//                "postTime"          : timeOffset1,
                "likes"           : likes,
                "documentID": newPostID,
                "rating": self.ratingValue ?? "",
                "productName": self.searchText ?? "",
                "productDetailPageURL": self.poductDetailPageUrl ?? "",
                "location": "" ?? "",
                "token": token ?? ""
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                    ProgressHUD.showError("Photo Save Error: \(err.localizedDescription)")
                } else {
                    print("Document successfully written!")
                    
                    
                     /***********product table***********/
                    
                    let db = Firestore.firestore()
                    
                    db.collection("products").document().setData([
                        "photoURL": photoURL ,
                        "productDetailPageURL": self.poductDetailPageUrl ?? "",
                        "productName": self.searchText ?? ""
                        

                    ]){ err in
                        if let err = err {
                            print("Error writing document: \(err)")
                            ProgressHUD.showError("Error : \(err.localizedDescription)")
                        } else {
                            
                            print("Document successfully committed!")
                        }
                    }
            
                    /***********product table***********/
                    
                    let finalcomment = users.username! + " " + "created on new product post"
                    print("finalcomment:::\(finalcomment)")
                    
                    db.collection("activity").document().setData([
                        "uid": "" ,
                        "currentUserUID": API.User.CURRENT_USER?.uid ?? "empty",
                        "currentUserName": users.username ?? "empty" ,
                        "activityName": finalcomment ,
                        "userName"  : ""
                        
                    ]){ err in
                        if let err = err {
                            print("Error writing document: \(err)")
                            ProgressHUD.showError("Error : \(err.localizedDescription)")
                        } else {
                            
                            print("Document successfully committed!")
                        }
                    }
                    
                    
                    
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
                    
                    if self.skipBool == true {
                    
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let vc         =  storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
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
    
//    func textFieldShouldReturn(_ captionTextView: UITextView) -> Bool {
//        self.view.endEditing(true)
//        return true
//    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
       
    }
   
    
}
extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        if #available(iOS 11.0, *) {
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        } else {
            // Fallback on earlier versions
        }
        return formatter
    }()
}


extension CameraViewController: XMLParserDelegate {
    
    // initialize results structure
    
//    func parserDidStartDocument(_ parser: XMLParser) {
//        results = [[:]]
//    }
    
    // start element
    //
    // - If we're starting a "record" create the dictionary that will hold the results
    // - If we're starting one of our dictionary keys, initialize `currentValue` (otherwise leave `nil`)
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == recordKey {
            currentDictionary = [:]
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        } else if dictionaryKeys1.contains(elementName){
            
            currentValue = ""
        } else if dictionaryKeys2.contains(elementName){
            
            currentValue = ""
        } else if dictionaryKeys3.contains(elementName){

            currentValue = ""
            
        }

        
    }
    
    // found characters
    //
    // - If this is an element we care about, append those characters.
    // - If `currentValue` still `nil`, then do nothing.
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string

    }
    
    // end element
    //
    // - If we're at the end of the whole dictionary, then save that dictionary in our array
    // - If we're at the end of an element that belongs in the dictionary, then save that value in the dictionary
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == recordKey {
            results.append(currentDictionary!)
            currentDictionary = nil
        } else if dictionaryKeys.contains(elementName) {
            currentDictionary![elementName] = currentValue
            currentValue = nil
        } else if dictionaryKeys1.contains(elementName) {
            
            currentDictionary![elementName] = currentValue
            currentValue = nil
        } else if dictionaryKeys2.contains(elementName) {
            
            currentDictionary![elementName] = currentValue
            currentValue = ""
            
        } else if dictionaryKeys3.contains(elementName){

            currentDictionary![elementName] = currentValue
            currentValue = ""
        }
        

    }
    
    // Just in case, if there's an error, report it. (We don't want to fly blind here.)
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        
        currentValue = nil
        currentDictionary = nil
        results.removeAll()
//        results = nil
    }
    
//         func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//            return 1
//        }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! amazonProductListTableViewCell
        

        let item = results[indexPath.row]
        print("productItem:::\(item)")

                cell.amazonProductTitle?.text =  item["Title"]
        


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        ref = Database.database().reference()
//        ref?.child("products").childByAutoId().setValue(searchBar.text)
        
        if let indexPath = tableView.indexPathForSelectedRow  {
            let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
           

           let item = self.results[indexPath.row]
            
          
            
            
            
            
//            searchLoaction.text = autocompleteplaceArray[indexPath.row]
//            PrefsManager.sharedinstance.lastlocation = searchLoaction.text
         
            UIView.animate(withDuration: 1, animations: {
                self.searchBar.text = (currentCell.textLabel?.text)
                
                self.searchBar.text = item["Title"]
                self.poductDetailPageUrl = item["DetailPageURL"]
                print("poductDetailPageUrl::::\(String(describing: self.poductDetailPageUrl))")
                self.AISNid = item["ASIN"]
                print("ASINid:::\(String(describing: self.AISNid))")
                self.searchText = self.searchBar.text
                print("searchText::::\(String(describing: self.searchText))")
                self.ImageByItemId = item["URL"]
                print("ImageByItemId:::\(String(describing: self.ImageByItemId))")
                
                if let photoURL = self.ImageByItemId {
                    self.photoImageView.image = nil
                    if  photoURL != "" {
                        Manager.shared.loadImage(with: URL(string : photoURL)!, into: self.photoImageView)

                        DispatchQueue.global().async {
                            
                            
                            let data = try? Data(contentsOf: URL(string: photoURL)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                            DispatchQueue.main.async {
                                self.selectedImage = UIImage(data: data!)
                                print("photoimageview:::\(String(describing: self.selectedImage))")
                                self.setButtons()
                            }
                        }
                       
                        //
                    }
                }

            }) { (true) in
                
//                self.ImageByItemId = item["LargeImage"]
//                self.getProductImage(itemid: self.AISNid!)
//                self.ImageByItemId = item["URL"]
//                print("ImageByItemId:::\(String(describing: self.ImageByItemId))")
            }
            
        }
        
        tableView.isHidden = true
        
    }
  
}
 

