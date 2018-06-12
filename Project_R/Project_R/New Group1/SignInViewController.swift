////
////  SignInViewController.swift
////  Blocstagram
////
////  Created by ddenis on 1/1/17.
////  Copyright © 2017 ddApps. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//
//class SignInViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate {
//
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var signInButton: UIButton!
//    @IBOutlet weak var termsofservicelabel: UITextView!
//
//    // MARK: - View Lifecycle
//    var Userdefaults = UserDefaults.standard
//    var authHandle: AuthStateDidChangeListenerHandle!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let clouds = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
//        self.emailTextField.delegate = self
//        self.passwordTextField.delegate = self
//
//        self.termsofservicelabel.delegate = self
//        let str                     = "By signing up, you agree to our Terms of Service."
//        let attributedString        = NSMutableAttributedString(string: str)
//        let foundRange              = attributedString.mutableString.range(of: "Terms of Service")
//        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: "", range: foundRange)
//        termsofservicelabel.attributedText = attributedString
//        termsofservicelabel.textColor      = clouds
//        termsofservicelabel.textAlignment  = .center
//        termsofservicelabel.font = UIFont(name: "Avenir-Medium", size: 13)
//
//        emailTextField.backgroundColor = .clear
//        emailTextField.tintColor = .white
//        emailTextField.textColor = .white
//        emailTextField.borderStyle = .none
//
//        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: clouds])
//
//        let bottomLayerEmail = CALayer()
//        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
//        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
//        emailTextField.layer.addSublayer(bottomLayerEmail)
//        emailTextField.clipsToBounds = true
//        emailTextField.autocorrectionType = .no
//
//        passwordTextField.backgroundColor = .clear
//        passwordTextField.tintColor = .white
//        passwordTextField.textColor = .white
//        passwordTextField.borderStyle = .none
//        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: clouds])
//        passwordTextField.autocorrectionType = .no
//
//        let bottomLayerPassword = CALayer()
//        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
//        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
//        emailTextField.layer.addSublayer(bottomLayerPassword)
//        passwordTextField.layer.addSublayer(bottomLayerPassword)
//        passwordTextField.clipsToBounds = true
//
//        signInButton.layer.cornerRadius = 5
//
//        // set handlers to text field objects
//        handleTextField()
//
//        // initially disable button
//        disableButton()
//
//    }
//
//
//    // Automatically Log Current User In
//    // if there is a current user segue to the tab bar controller in View Did Appear
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        if API.User.CURRENT_USER != nil {
//            // segue to the Tab Bar Controller
//            self.performSegue(withIdentifier: "signInToTabBar", sender: nil)
//        }
//    }
//
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//
//        let storyboard = UIStoryboard(name: "Start", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "terms")
//        self.present(vc, animated: true, completion: nil)
//
//        return false
//
//    }
//
//
//    // MARK: - Handle the Text Fields
//
//    func handleTextField() {
//        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//    }
//
//
//    @objc func textFieldDidChange() {
//        // guard against username, email and password all not being empty
//        guard
//            let email = emailTextField.text, !email.isEmpty
////            let password = passwordTextField.text, !password.isEmpty
//            else {
//                // disable SignUp button if ANY are not empty
//                disableButton()
//                return
//        }
//        // enable SignUp button if they are ALL not empty
//        enableButton()
//    }
//
//
//    func disableButton() {
//        signInButton.isEnabled = false
//        signInButton.alpha = 0.2
//    }
//
//
//    func enableButton() {
//        signInButton.isEnabled = true
//        signInButton.alpha = 1.0
//    }
//
//    // MARK: - Dismiss Keyboard
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        emailTextField.resignFirstResponder()
//        passwordTextField.resignFirstResponder()
//    return true
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
//
//
//    // MARK: - Sign In User Method
//
//    @IBAction func signIn(_ sender: Any) {
//        //dismiss keyboard
//        view.endEditing(true)
//
//        // show the progress to the user
//        ProgressHUD.show("Starting sign-in...", interaction: false)
//
//
//        let mobileNumber = "+91" + emailTextField.text!
//
//        self.Userdefaults.set(mobileNumber, forKey: "mobileNumber")
//
//        print("mobileNumber::::\(mobileNumber)")
//
//        sendOTPCode()
//
//
//
//
//
//        // use the signIn class method of the AuthService class
//        AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
//            // on success segue to the Tab Bar Controller
//            API.User.observeCurrentUser { user in
//
//                guard let currentUser = Auth.auth().currentUser else {
//                    return
//                }
//
//                PrefsManager.sharedinstance.UIDfirebase = currentUser.uid
//                PrefsManager.sharedinstance.username  = user.username!
//                PrefsManager.sharedinstance.userEmail = user.email!
//                PrefsManager.sharedinstance.imageURL  = user.profileImageURL!
//
//                ProgressHUD.showSuccess("Sucessfully signed in.")
//                self.performSegue(withIdentifier: "signInToTabBar", sender: nil)
//
//            }
//
//        }, onError: { errorString in
//            ProgressHUD.dismiss()
//            self.showErrorAlert(message: errorString ?? "Server error")
//        })
//    }
//
//
//    func sendOTPCode() {
//
//        let mymobilenumber = Userdefaults.string(forKey: "mobileNumber")
//
//        PhoneAuthProvider.provider().verifyPhoneNumber(mymobilenumber!, uiDelegate: nil, completion:
//            {
//                (verificationID, error) in
//
//                self.Userdefaults.set(verificationID, forKey: "authVerificationID")
//
//                if error != nil
//                {
//                    print ("insde SendCode, there is error")
//
////                    self.infoLabel.text = "Please check the Number"
//
////                    self.enterCode.alpha = 0
//
//                    print("error: \(String(describing: error?.localizedDescription))")
//
//                }
//                else
//                {
//                    print ("code sent")
//
////                    self.infoLabel.text = ""
//                    self.emailTextField.allowsEditingTextAttributes = false
////                    self.enterCode.alpha = 1
//
//
//                }
//        })
//
//    }
//    func loginusingOTP(OTPtext: String) {
//        let db = Firestore.firestore()
//        let verificationID = self.Userdefaults.string(forKey: "authVerificationID")
//
//        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!,
//                                                                                      verificationCode: OTPtext)
//        Auth.auth().signIn(with: credential)
//        {
//            (user, error) in
//            if error != nil
//            {
//                print("error: \(String(describing: error?.localizedDescription))")
//            }
//            else if user != nil
//            {
//
//                print("Phone number: \(String(describing: user?.phoneNumber))")
//                let userInfo = user?.providerData[0]
//                print("Provider ID: \(String(describing: userInfo?.providerID))")
//
//                var _: DocumentReference? = nil
//
//                print("currentUser:::\(String(describing: currentUser))")
//
//                db.collection("users").document(currentUser!).setData([
//                    "User_Phone_number": user?.phoneNumber as Any,
//                    "User_ID": currentUser as Any
//
//                ]) { err in
//                    if let err = err {
//                        print("Error writing document: \(err)")
//                    } else {
//                        print("Document successfully written!")
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let controller = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
//                        self.present(controller, animated: true, completion: nil)
//                    }
//                }
//
//            } else {
//
//                print("error::::::")
//
//            }
//
//        }
//
//    }
//
//    @IBAction func Forget(_ sender: Any) {
//
//        let storyboard = UIStoryboard(name: "Start", bundle: nil)
//        let vc         =  storyboard.instantiateViewController(withIdentifier: "forget") as! ForgetPassword
//        self.present(vc, animated: true, completion: nil)
//
//    }
//
//}
//
//extension SignInViewController {
//
//    func showErrorAlert(message : String){
//
//
//        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//
//    }
//
//
//}
