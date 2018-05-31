//
//  SignUpViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var selectedProfilePhoto: UIImage?
    var imagePicker = UIImagePickerController()
    
    @IBAction func dismissOnTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clouds = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        self.imagePicker.delegate = self
        
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .savedPhotosAlbum
        
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        usernameTextField.backgroundColor = .clear
        usernameTextField.tintColor = .white
        usernameTextField.textColor = .white
        usernameTextField.borderStyle = .none
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: clouds])
        usernameTextField.autocorrectionType = .no
        
        let bottomLayerUsername = CALayer()
        bottomLayerUsername.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerUsername.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        usernameTextField.layer.addSublayer(bottomLayerUsername)
        usernameTextField.clipsToBounds = true
        
        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        emailTextField.borderStyle = .none
        emailTextField.autocorrectionType = .no
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: clouds])
        
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        emailTextField.clipsToBounds = true
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .white
        passwordTextField.textColor = .white
        passwordTextField.borderStyle = .none
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: clouds])
        passwordTextField.autocorrectionType = .no
        
        
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayerPassword)
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        passwordTextField.clipsToBounds = true
        
        signupButton.layer.cornerRadius = 5
        
        // add a tap gesture to the profile image for users to pick their avatar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(popAlert))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds      = true
        
        // set handlers to text field objects
        handleTextField()
        
        // initially disable button
        disableButton()
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


//MARK:UIImagePickerControllerDelegate
func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
    
    picker .dismiss(animated: true, completion: nil)
    profileImageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
}
func imagePickerControllerDidCancel(picker: UIImagePickerController){
    print("picker cancel.")
}


    // MARK: - Handle the Text Fields
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    
    
    @objc func textFieldDidChange() {
        // guard against username, email and password all not being empty
        guard
            let username = usernameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
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
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
        ProgressHUD.show("Starting sign-up...", interaction: false)
        
        // convert selected image to JPEG Data format to push to file store
        if let profileImage = self.selectedProfilePhoto, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
            AuthService.signUp(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Sucessfully signed up.")
                // segue to the Tab Bar Controller
                if PrefsManager.sharedinstance.isFirstTime == true{
                    
                    
                    let when = DispatchTime.now() + 0
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        
                        self.performSegue(withIdentifier: "signUpToTabBar", sender: nil)
                        
                    }
                    
                    
                }else{
                    let when = DispatchTime.now() + 0
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        
                      
                        let storyboard = UIStoryboard(name: "Start", bundle: nil)
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "onboardvc")
                        self.present(initialViewController, animated: true, completion: nil)
                        
                    }
                }
                
            }, onError: { (errorString) in
                ProgressHUD.dismiss()
                self.showErrorAlert(message: errorString!)
            })
        } else {
            
            ProgressHUD.dismiss()
            self.showErrorAlert(message: "Your profile image can not be empty. Tap it to set it.")
        }
    }
    
}


// MARK: - ImagePicker Delegate Methods

extension SignUpViewController: UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image       = self.imageOrientation(image)
            profileImageView.contentMode = .scaleAspectFill
            selectedProfilePhoto         = self.imageOrientation(image)
        }
        
        dismiss(animated: true)
    }
    
}

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


