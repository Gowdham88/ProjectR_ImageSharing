//
//  SignUpViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebasePhoneAuthUI
import FirebaseAuthUI
import FirebaseFirestore

public let currentUser = Auth.auth().currentUser?.uid

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
//    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
//    @IBOutlet weak var profileImageView: UIImageView!
    
    var selectedProfilePhoto: UIImage?
//    var imagePicker = UIImagePickerController()
    var Userdefaults = UserDefaults.standard
    var authHandle: AuthStateDidChangeListenerHandle!
    var sendOTP:Bool = false
    
    @IBAction func dismissOnTap(_ sender: Any) {
        
        sendOTPCode()
        
//        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.titleLabel?.text = "Send OTP"
//        let clouds = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
//        self.imagePicker.delegate = self
        
//        self.imagePicker.allowsEditing = false
//        self.imagePicker.sourceType = .savedPhotosAlbum
        
//        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
//        usernameTextField.backgroundColor = .clear
//        usernameTextField.tintColor = .white
//        usernameTextField.textColor = .white
//        usernameTextField.borderStyle = .none
//
//        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: clouds])
//        usernameTextField.autocorrectionType = .no
        
//        let bottomLayerUsername = CALayer()
//        bottomLayerUsername.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
//        bottomLayerUsername.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
//        usernameTextField.layer.addSublayer(bottomLayerUsername)
//        usernameTextField.clipsToBounds = true
        
//        emailTextField.backgroundColor = .clear
//        emailTextField.tintColor = .white
//        emailTextField.textColor = .white
//        emailTextField.borderStyle = .none
//        emailTextField.autocorrectionType = .no
//        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: clouds])
        
//        let bottomLayerEmail = CALayer()
//        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
//        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
//        emailTextField.layer.addSublayer(bottomLayerEmail)
//        emailTextField.clipsToBounds = true
//
//        passwordTextField.backgroundColor = .clear
//        passwordTextField.tintColor = .white
//        passwordTextField.textColor = .white
//        passwordTextField.borderStyle = .none
//        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: clouds])
//        passwordTextField.autocorrectionType = .no
//
//
//        let bottomLayerPassword = CALayer()
//        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
//        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
//        emailTextField.layer.addSublayer(bottomLayerPassword)
//        passwordTextField.layer.addSublayer(bottomLayerPassword)
//        passwordTextField.clipsToBounds = true
        
        signupButton.layer.cornerRadius = 15
        
        // add a tap gesture to the profile image for users to pick their avatar
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(popAlert))
//        profileImageView.addGestureRecognizer(tapGesture)
//        profileImageView.isUserInteractionEnabled = true
        
//        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
//        profileImageView.clipsToBounds      = true
        
        // set handlers to text field objects
        handleTextField()
        
        // initially disable button
        disableButton()
        
//        if Defaults[.islogin] == true {
//            //Go to Home with animation false
////             self.performSegue(withIdentifier: "signUpToTabBar", sender: nil)
//            let storyboard = UIStoryboard(name: "Home", bundle: nil)
//            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
//            self.present(initialViewController, animated: true, completion: nil)
//        }
    }
   
    
    // MARK: - Handle the User Profile Picking
//    func handleProfileImageView() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        present(imagePickerController, animated: true)
//
//    }
//    @objc func popAlert() {
//    let alert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
//        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default){ action in
//            self.openCamera()
//        }
//    let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
//    {
//        UIAlertAction in
//        self.handleProfileImageView()
//    }
//    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
//    {
//        UIAlertAction in
//    }
//    cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
//
//
//    // Add the actions
//
//    imagePicker.delegate = self
//    alert.addAction(cameraAction)
//    alert.addAction(gallaryAction)
//    alert.addAction(cancelAction)
//
//    alert.popoverPresentationController?.sourceView = self.view
//    alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
//    self.present(alert, animated: true, completion: nil)
//
//    }

//func openCamera() {
//
//    if(UIImagePickerController .isSourceTypeAvailable(.camera))
//    {
//        self.imagePicker.sourceType = .camera
//        self.imagePicker.delegate = self
//
//    }
//    present(imagePicker, animated: true, completion: nil)
//}


//MARK:UIImagePickerControllerDelegate
//func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
//
//    picker .dismiss(animated: true, completion: nil)
//    profileImageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
//}
//func imagePickerControllerDidCancel(picker: UIImagePickerController){
//    print("picker cancel.")
//}


    // MARK: - Handle the Text Fields
    func handleTextField() {
//        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    
    
    @objc func textFieldDidChange() {
        // guard against username, email and password all not being empty
        guard
//            let username = usernameTextField.text, !username.isEmpty,
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        let codestring = passwordTextField.text
        
        if codestring?.count == 6 {
            
            textField.resignFirstResponder()
            
            loginusingOTP(OTPtext: codestring!)
            
            return true
            
        } else {
            
            print("Enter 6 digit code")
            return true
            
        }
        return true
    }
    // MARK: - Dismiss Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    // MARK: - Sign Up User Method
    
    @IBAction func signUp(_ sender: Any) {
        // dismiss keyboard
        view.endEditing(true)
        
        // show the progress to the user
//        ProgressHUD.show("Starting sign-up...", interaction: false)

        
        if sendOTP == false {
        let mobileNumber = "+91" + emailTextField.text!
        
        self.Userdefaults.set(mobileNumber, forKey: "mobileNumber")
        
        print("mobileNumber::::\(mobileNumber)")
//        UserDefaults.standard.set("value", forKey: "emailTextField")
        Userdefaults.synchronize()
        
        sendOTPCode()
        sendOTP = true
        
        } else {
            
            let codestring = passwordTextField.text
            
            if codestring?.count == 6 {
                
                
                loginusingOTP(OTPtext: codestring!)
                
                
            } else {
                
                print("Enter 6 digit code")
                
            }
            
        }
        // convert selected image to JPEG Data format to push to file store
//        if let profileImage = self.selectedProfilePhoto, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
//            AuthService.signUp(email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
//                ProgressHUD.showSuccess("Sucessfully signed up.")
//                // segue to the Tab Bar Controller
//                if PrefsManager.sharedinstance.isFirstTime == true{
//
//
//                    let when = DispatchTime.now() + 0
//                    DispatchQueue.main.asyncAfter(deadline: when) {
//
//                        self.performSegue(withIdentifier: "signUpToTabBar", sender: nil)
//
//                    }
//
//
//                }else{
//                    let when = DispatchTime.now() + 0
//                    DispatchQueue.main.asyncAfter(deadline: when) {
//
//
//                        let storyboard = UIStoryboard(name: "Start", bundle: nil)
//                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "onboardvc")
//                        self.present(initialViewController, animated: true, completion: nil)
//
//                    }
//                }
//
//            }, onError: { (errorString) in
//                ProgressHUD.dismiss()
//                self.showErrorAlert(message: errorString!)
//            })
//        } else {
//
//            ProgressHUD.dismiss()
//            self.showErrorAlert(message: "Your profile image can not be empty. Tap it to set it.")
//        }
    }
    
    
    func sendOTPCode() {
        
        let mymobilenumber = Userdefaults.string(forKey: "mobileNumber")
//        PhoneAuthProvider.provider().verifyPhoneNumber(mymobilenumber!) { (verificationID, error) in
        
        PhoneAuthProvider.provider().verifyPhoneNumber(mymobilenumber!, uiDelegate: nil
            , completion: { (verificationID, error) in
           
//        PhoneAuthProvider.provider().verifyPhoneNumber(mymobilenumber!, uiDelegate: nil, completion:
//            {
//                (verificationID, error) in
            
                self.Userdefaults.set(verificationID, forKey: "authVerificationID")
                
                if error != nil
                {
                    print ("insde SendCode, there is error")
                    
                    //                    self.infoLabel.text = "Please check the Number"
                    
                    //                    self.enterCode.alpha = 0
                    
                    print("error: \(String(describing: error?.localizedDescription))")
                    
                } else {
                    print ("code sent")
                    
                    //                    self.infoLabel.text = ""
                    self.emailTextField.allowsEditingTextAttributes = false
                    //                    self.enterCode.alpha = 1
                    
                    
                }
        })
        
    }
    
    func loginusingOTP(OTPtext: String) {
        let db = Firestore.firestore()
        let verificationID = self.Userdefaults.string(forKey: "authVerificationID")
        
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!,
                                                                                      verificationCode: OTPtext)
        Auth.auth().signIn(with: credential)
        {
            (user, error) in
            if error != nil
            {
                print("error: \(String(describing: error?.localizedDescription))")
            }
            else if user != nil
            {
                
                print("Phone number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
                
//                var _: DocumentReference? = nil
                
                print("currentUser:::\(String(describing: currentUser))")
//                db.collection("users").document(currentUser!).setData([
//                    "User_Phone_number": user?.phoneNumber as Any,
//                    "uid": currentUser as Any
                
//                ]) { err in
//                    if let err = err {
//                        print("Error writing document: \(err)")
//                    } else {
//                        print("Document successfully written!")
                        if PrefsManager.sharedinstance.isFirstTime == true{
                            
                            
                            let when = DispatchTime.now() + 0
                            DispatchQueue.main.asyncAfter(deadline: when) {
                                
//                                self.performSegue(withIdentifier: "signUpToTabBar", sender: nil)
                                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                                let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarID")
                                self.present(initialViewController, animated: true, completion: nil)
                                
//                                Defaults[.username] = Your_User_Name
//                                Defaults[.phoneNo] = user?.phoneNumber
//                                Defaults[.islogin] = true
                                
                            }
                            
                            
                        }else{
                            let when = DispatchTime.now() + 0
                            DispatchQueue.main.asyncAfter(deadline: when) {
                                let storyboard = UIStoryboard(name: "Start", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "onboardvc") as! OnboardVc
                                vc.phoneNumber = (user?.phoneNumber)!
                                vc.uid = currentUser!
                                self.present(vc, animated: true, completion: nil)
                                
                               
                                
                            }
                        }
                        
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let controller = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
//                        self.present(controller, animated: true, completion: nil)
                        
//                        let storyboard = UIStoryboard(name: "Start", bundle: nil)
//                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "onboardvc")
//                        self.present(initialViewController, animated: true, completion: nil)
                        
                    }
                }
                print("error::::::")
            }
        
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let codestring = passwordTextField.text
        
        if codestring?.count == 6 {
            
            self.view.endEditing(true)
            
            loginusingOTP(OTPtext: codestring!)
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let codestring = passwordTextField.text
        
        if codestring?.count == 6 {
            
            self.view.endEditing(true)
            
            loginusingOTP(OTPtext: codestring!)
            
        }
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        let codestring = passwordTextField.text
//
//        if codestring?.count == 6 {
//
//            textField.resignFirstResponder()
//
//            loginusingOTP(OTPtext: codestring!)
//
//            return true
//
//        } else {
//
//            print("Enter 6 digit code")
//            return true
//
//        }
//
//    }
    
    
}


// MARK: - ImagePicker Delegate Methods

//extension SignUpViewController: UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
////            profileImageView.image       = self.imageOrientation(image)
////            profileImageView.contentMode = .scaleAspectFill
//            selectedProfilePhoto         = self.imageOrientation(image)
//        }
//
//        dismiss(animated: true)
//    }
//
//}

extension SignUpViewController {
    
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

//extension DefaultsKeys {
////    static let username = DefaultsKey<String?>("username")
//    static let phoneNo = DefaultsKey<String?>("phoneNo")
//    static let islogin = DefaultsKey<Bool?>("islogin")
//}
