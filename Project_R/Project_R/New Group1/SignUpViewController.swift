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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//    @IBOutlet weak var profileImageView: UIImageView!
    
    var selectedProfilePhoto: UIImage?
//    var imagePicker = UIImagePickerController()
    var Userdefaults = UserDefaults.standard
    var authHandle: AuthStateDidChangeListenerHandle!
    var sendOTP:Bool = false
    var mobileNumber = String()
    
    @IBAction func dismissOnTap(_ sender: Any) {
        
        print("Dismiss on TAP")
        sendOTPCode()
        
//        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if Auth.auth().currentUser != nil {
            
            TabBarLogin()
            
        }
        
        activityIndicator.isHidden = true
        signupButton.titleLabel?.text = "Send OTP"

        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        signupButton.layer.cornerRadius = 15
   
        handleTextField()
        
        // initially disable button
        disableButton()
        
    }
 
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
    }
    
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: value)
        return  result
    }
    
  
    // MARK: - Dismiss Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // MARK: - Sign Up User Method
    
    @IBAction func signUp(_ sender: Any) {
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
 
        view.endEditing(true)
        
        if sendOTP == false {
            
        mobileNumber = "+91" + emailTextField.text!
        
        self.Userdefaults.set(mobileNumber, forKey: "mobileNumber")
            
        print("mobileNumber::::\(mobileNumber)")
          
        Userdefaults.synchronize()
        
        print("signUp SEND OTP = False")
            
        sendOTPCode()
            
        sendOTP = true
        
        } else {
            
            let codestring = passwordTextField.text
            
            if codestring?.count == 6 {
                
                enableButton()
                loginusingOTP(OTPtext: codestring!)
                
                
            } else {
                 print("Enter 6 digit code")
                
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                
                let alert = UIAlertController(title: "Invalid OTP", message: "Enter a valid OTP", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
            
        }

    }
    
    
    func sendOTPCode() {
        
        
        PhoneAuthProvider.provider().verifyPhoneNumber(mobileNumber, uiDelegate: nil, completion: { (verificationID, error) in
            
            print("verificationID: \(String(describing: verificationID))")
            
            self.Userdefaults.set(verificationID, forKey: "authVerificationID")
            
            if let error = error {
                
                print("Error: \(error.localizedDescription)")
                
                return
                
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            print ("code sent")
            self.signupButton.setTitle("Login", for: .normal)
            
            //                    self.infoLabel.text = ""
            self.emailTextField.allowsEditingTextAttributes = false
            //                    self.enterCode.alpha = 1
            
        })
        
    }
    
    func TabBarLogin() {
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarID")
        self.present(initialViewController, animated: true, completion: nil)
        
    }
    
  
    
    var posts = [Post]()
    var users = [Users]()
    var snapshot :DocumentSnapshot?
   
    
    
    
    
    func loginusingOTP(OTPtext: String) {
        _ = Firestore.firestore()
        let verificationID = self.Userdefaults.string(forKey: "authVerificationID")
        
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!,
                                                                                      verificationCode: OTPtext)
        Auth.auth().signIn(with: credential)
        {
            (user, error) in
            
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            
           if user != nil
            {
                let db = Firestore.firestore()

                print("users uid: \(user!.uid)")
                
                let dbvalue = db.collection("users").document(user!.uid)

                print("dbvalue: \(dbvalue)")
                
                dbvalue.getDocument { (snapshot, error) in
                    
                    print("snapshot: \(snapshot?.data())")
                    
                    guard let snapshot = snapshot else {
                        
                        let when = DispatchTime.now() + 0
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            
                           
                            let storyboard = UIStoryboard(name: "Start", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "onboardvc") as! OnboardVc
                            vc.phoneNumber = (user?.phoneNumber)!
                            vc.uid = currentUser!
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                        
                        return
                        
                    }
                    
                    if snapshot.exists {
                        
                        
                        let when = DispatchTime.now() + 0
                                                    DispatchQueue.main.asyncAfter(deadline: when) {
                        
                                                        self.TabBarLogin()
                        
                                                    
                        }
                        
                        
                        return
                        
                    } else {
                        
                        
                        let when = DispatchTime.now() + 0
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            
                            
                            let storyboard = UIStoryboard(name: "Start", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "onboardvc") as! OnboardVc
                            vc.phoneNumber = (user?.phoneNumber)!
                            vc.uid = currentUser!
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                        
                        return
                        
                    }
                    
                    
                }
                
                
                print("Phone number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
                
                print("currentUser:::\(String(describing: currentUser))")
                
                
           } else {
            
                print("error: \(String(describing: error?.localizedDescription))")
                
//                self.showErrorAlert(message: "Oops! Invalid Login.")
            
            }
            
        }
        

        
    }
        
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == emailTextField {
            
            enableButton()
            
            self.signupButton.setTitle("Get OTP", for: .normal)
            sendOTP = false
//            disableButton()
//            self.Userdefaults.removeObject(forKey: "mobileNumber")
        
        } else {
            
            self.signupButton.setTitle("Login", for: .normal)
            sendOTP = true
            disableButton()
            print(":::::Login::::::::")
            
        }
        
            print("passwordTextField has some text")
        
            let codestring = passwordTextField.text
        
            print(":::::Email text field tapped:::::")
        
//            if codestring?.count == 6 {
//
//                self.view.endEditing(true)
//
//                loginusingOTP(OTPtext: codestring!)
//           }
        
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
