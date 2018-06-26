//
//  OnboardVc.swift
//  SarvodayaHB
//
//  Created by CZ Ltd on 2/2/18.
//  Copyright © 2018 CZ Ltd. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebasePhoneAuthUI
import FirebaseAuthUI
import FirebaseFirestore


class OnboardVc: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var addProfileImageView: UIView!
    
    var selectedProfilePhoto: UIImage?
    var imagePicker = UIImagePickerController()
    var imageURL: String = ""
    var phoneNumber: String = ""
    var uid: String = ""
//    var Users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let clouds = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)

        
        PrefsManager.sharedinstance.isFirstTime = true
        
                self.imagePicker.delegate = self
        
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.usernameTextField.delegate = self
                self.emailTextField.delegate = self
        
//                usernameTextField.backgroundColor = .clear
//                usernameTextField.tintColor = .white
//                usernameTextField.textColor = .white
//                usernameTextField.borderStyle = .none
//
//                usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: clouds])
//                usernameTextField.autocorrectionType = .no
        
//        let bottomLayerEmail = CALayer()
//        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
//        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
//        usernameTextField.layer.addSublayer(bottomLayerEmail)
//        usernameTextField.clipsToBounds = true
        
        
//        emailTextField.backgroundColor = .clear
//        emailTextField.tintColor = .white
//        emailTextField.textColor = .white
//        emailTextField.borderStyle = .none
//        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: clouds])
//        emailTextField.autocorrectionType = .no
        
//        
//        let bottomLayerPassword = CALayer()
//        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
//        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
//        usernameTextField.layer.addSublayer(bottomLayerPassword)
//        emailTextField.layer.addSublayer(bottomLayerPassword)
//        emailTextField.clipsToBounds = true
        
        // add a tap gesture to the profile image for users to pick their avatar
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(popAlert))
                profileImageView.addGestureRecognizer(tapGesture)
                profileImageView.isUserInteractionEnabled = true
        
                profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
                profileImageView.clipsToBounds      = true
        
                self.addProfileImageView.layer.cornerRadius = addProfileImageView.frame.size.width/2
//                self.addProfileImageView.clipsToBounds = true
        
        addProfileImageView.layer.shadowColor = UIColor.black.cgColor
        addProfileImageView.layer.shadowOpacity = 0.2
        addProfileImageView.layer.shadowOffset = CGSize.zero
        addProfileImageView.layer.shadowRadius = 5
        self.view.addSubview(addProfileImageView)
        
        // set handlers to text field objects
        handleTextField()
        
        // initially disable button
        disableButton()

        // Do any additional setup after loading the view.
    }
    
        // MARK: - Dismiss Keyboard
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            emailTextField.resignFirstResponder()
            usernameTextField.resignFirstResponder()
        return true
        }
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
    
    // MARK: - Handle the Text Fields
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        // guard against username, email and password all not being empty
        guard
            let username = usernameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty
            //            let password = passwordTextField.text, !password.isEmpty
            else {
                // disable SignUp button if ANY are not empty
                disableButton()
                return
        }
        // enable SignUp button if they are ALL not empty
        enableButton()
    }
    
    func disableButton() {
        signupButton.isEnabled = false
        signupButton.alpha = 0.2
    }
    
    
    func enableButton() {
        signupButton.isEnabled = true
        signupButton.alpha = 1.0
    }
    
    // MARK: - Handle the User Profile Picking
        func handleProfileImageView() {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
    
        }
        @objc func popAlert() {
        let alert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default){ action in
                self.openCamera()
            }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.handleProfileImageView()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
    
    
        // Add the actions
    
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
    
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        self.present(alert, animated: true, completion: nil)
    
        }
    
    func openCamera() {
    
        if(UIImagePickerController .isSourceTypeAvailable(.camera))
        {
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
    
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    
//    MARK:UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
    
        picker .dismiss(animated: true, completion: nil)
        profileImageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        print("picker cancel.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func letStarted(_ sender: Any) {
        
//        PrefsManager.sharedinstance.isFirstTime = true
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.1, animations: {
            
            
            self.saveData(profileImageURL: self.imageURL, username: self.usernameTextField.text!, email: self.emailTextField.text!, uid: currentUser!);
//            ProgressHUD.show("Please wait...", interaction: false)

        }) { (success) in
                    ProgressHUD.dismiss()
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarID")
                    self.present(initialViewController, animated: true, completion: nil)
        }
        

        
       
    }

     func saveData(profileImageURL: String, username: String, email: String, uid: String){
//        ProgressHUD.show("Please wait...", interaction: false)
        let db = Firestore.firestore()
        db.collection("users").document(currentUser!).setData([
                    "username": username,
                    "User_Phone_number": phoneNumber,
                    "uid": uid,
                    "email":email,
                    "profileImageURL": profileImageURL
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        
                        print("Document successfully written!")
                        PrefsManager.sharedinstance.UIDfirebase = uid
                        PrefsManager.sharedinstance.username    = username
                        PrefsManager.sharedinstance.userEmail   = email
                        PrefsManager.sharedinstance.imageURL    = profileImageURL
                        ProgressHUD.dismiss()
                    }
                }
        
    }
    
    
}
extension OnboardVc: UINavigationControllerDelegate {


    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if let orginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageView.image = orginalImage
        } else { print ("error") }
//        picker.dismiss(animated: true, completion: nil)
    
        
//        dismiss(animated: true, completion: nil)
        var data = NSData()
        data = UIImageJPEGRepresentation(profileImageView.image!, 0.8)! as NSData
        // set upload path
        let uid = currentUser
        let storeRef = Storage.storage().reference(forURL: Constants.fileStoreURL).child("profile_image").child(uid!)

        storeRef.putData(data as Data, metadata: nil, completion: { (metaData, error) in
                            if error != nil {
                                print("Profile Image Error: \(String(describing: error?.localizedDescription))")
                                return
                            }
            
                            // if there's no error
                            // get the URL of the profile image in the file store
                self.imageURL = (metaData?.downloadURL()?.absoluteString)!
                //                            self.imageURL = profileImageURL!
                print("imageurl::::\(self.imageURL)")
            
            
                            // set the user information with the profile image URL
            self.saveData(profileImageURL: self.imageURL, username: self.usernameTextField.text!, email: self.emailTextField.text!, uid: uid!)
            
                        })
        
 

        dismiss(animated: true)
    }

}
extension OnboardVc {
    
    func showErrorAlert(message : String){
        
        
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
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
extension Data {
    
    var format: String {
        
        let array = [UInt8](self)
        let ext: String
        switch (array[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "unknown"
        }
        return ext
    }
}
