//
//  ForgetPassword.swift
//  SarvodayaHB
//
//  Created by Suraj B on 26/01/2018.
//  Copyright © 2018 CZ Ltd. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgetPassword: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var editUserEmail: UITextField!
    
    @IBOutlet weak var btnReset: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let clouds = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        self.editUserEmail.delegate = self
        
        
        editUserEmail.backgroundColor = .clear
        editUserEmail.tintColor = .white
        editUserEmail.textColor = .white
        editUserEmail.borderStyle = .none
        
        editUserEmail.attributedPlaceholder = NSAttributedString(string: editUserEmail.placeholder!, attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: clouds])
        
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        editUserEmail.layer.addSublayer(bottomLayerEmail)
        editUserEmail.clipsToBounds = true
        editUserEmail.autocorrectionType = .no
        
        
        
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        editUserEmail.layer.addSublayer(bottomLayerPassword)
        
        
        btnReset.layer.cornerRadius = 5
        
        // set handlers to text field objects
        handleTextField()
        
        // initially disable button
        disableButton()

        // Do any additional setup after loading the view.
    }
    
    func handleTextField() {
        
        editUserEmail.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func textFieldDidChange() {
        // guard against username, email and password all not being empty
        guard
            let email = editUserEmail.text, !email.isEmpty
            else {
                // disable SignUp button if ANY are not empty
                disableButton()
                return
        }
        // enable SignUp button if they are ALL not empty
        enableButton()
    }
    
    
    func disableButton() {
        btnReset.isEnabled = false
        btnReset.alpha = 0.2
    }
    
    
    func enableButton() {
        btnReset.isEnabled = true
        btnReset.alpha = 1.0
    }
    
    // MARK: - Dismiss Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        editUserEmail.resignFirstResponder()
       
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    @IBAction func ButtonResetPassword(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if let email = editUserEmail.text, email != "" {
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                
                if let error = error {
                    ProgressHUD.dismiss()
                    self.showErrorAlert(message: error.localizedDescription)
                    
                    print("forgot password error:::::::",error.localizedDescription)
                    
                } else {
                    sender.isEnabled = false
                    
                    //                 self.showAlertMessagepop(title: "Password reset email sent")
                    let Alert = UIAlertController(title: "Success", message: "A reset link has been sent to your email", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { _ in
//                        self.dismiss(animated: true, completion: nil)
                    }
                    Alert.addAction(okAction)
                    self.present(Alert, animated: true, completion:nil )
                    
                    //                 self.dismiss(animated: true, completion: nil)
                }
            }
            
        } else {
            
            ProgressHUD.dismiss()
            self.showErrorAlert(message: "Enter user email.")
            
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func ButtonClose(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
   
}

extension ForgetPassword {
    
    func showErrorAlert(message : String){
        
        
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}

