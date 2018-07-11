//
//  verification.swift
//  Project_R
//
//  Created by CZSM G on 18/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth
import AWSCore
import Alamofire
import AWSAPIGateway
import SHXMLParser
import Nuke

class verification: UIViewController, UIImagePickerControllerDelegate {
  
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var addproductLbl: UILabel!
    @IBOutlet weak var billImg: UIImageView!
    @IBOutlet weak var attachBtn: UIButton!
    @IBOutlet weak var addBill: UILabel!
    @IBOutlet weak var attachImg: UIImageView!
    @IBOutlet weak var backOption: UIBarButtonItem!
    
    var selectedImage: UIImage?
    
    var imageVc: UIImage?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.Navigation bar title color
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //2.Attach button corner radius
        attachBtn.layer.cornerRadius = 15
       
        
        //Bill image:-
        billImg.clipsToBounds = true
        billImg.layer.cornerRadius = 20
        billImg.layer.shadowColor = UIColor.black.cgColor
        billImg.layer.shadowOpacity = 0.2
        billImg.layer.shadowOffset = CGSize(width: -1, height: 1)
        billImg.layer.shadowRadius = 4
        billImg.layer.masksToBounds = false
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadBillFromFile))
        billImg.addGestureRecognizer(tapGesture)
        billImg.isUserInteractionEnabled = true
        billImg.layer.cornerRadius = 2
        tabBarController?.tabBar.isHidden = true
        
        print("Get image URL:::",imageVc)
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        setBtn()
    }
    
    @objc func uploadBillFromFile(){
        
        let Alert: UIAlertController = UIAlertController(title: "Attach your bill", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
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
    
    func setBtn(){
        if billImg != nil {
            attachBtn.isEnabled = true
            attachBtn.alpha = 1.0
            backOption.isEnabled = true
            
        } else {
            attachBtn.isEnabled = false
            attachBtn.alpha = 0.2
            backOption.isEnabled = false
        }
    }
    
    @IBAction func attachBill(_ sender: Any) {
        
        shareverficationPost()
        
        
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)
        
        setBtn()

    }
    
    func saveToDatabases(photoURL: String) {
      
        
        let ref = Database.database().reference()
        let postsReference = ref.child("verification")
        let newPostID = postsReference.childByAutoId().key
        
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
//        let likes   = [currentUserID : false]
        
        var users : Users!
        API.User.observeCurrentUser { (user) in
            
            let db = Firestore.firestore()
            db.collection("posts").document(postNewID!).updateData([

                  "BillphotoURL": photoURL,
                  "value": false
                
            ]) { err in
                if let err = err {
                    print("Error writing document: \(String(describing: err))")
                    ProgressHUD.showError("Photo Save Error: \(String(describing: err.localizedDescription))")
                } else {
                    
                    print("Document successfully written!")
                }
            }
            
            
        }
        
    }
    
    
    @IBAction func cancelVerification(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc         =  storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func shareverficationPost(){
        // show the progress to the user
//        ProgressHUD.show("Sharing started...", interaction: false)

        // convert selected image to JPEG Data format to push to file store
        if let photo = selectedImage, let imageData = UIImageJPEGRepresentation(photo, 0.1) {

            // get a unique ID
            let photoIDString = NSUUID().uuidString

            // get a reference to our file store
            let storeRef = Storage.storage().reference(forURL: Constants.fileStoreURL).child("verification").child(photoIDString)

            // push to file store
            storeRef.putData(imageData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    ProgressHUD.showError("Photo Save Error: \(String(describing: error?.localizedDescription))")
                    return
                }

                // if there's no error
                // get the URL of the photo in the file store
                let photoURL = metaData?.downloadURL()?.absoluteString

                // and put the photoURL into the database
                self.saveToDatabases(photoURL: photoURL!)
                //                self.saveActivity()
                //                self.getname()
            })
        } else {
            ProgressHUD.showError("Your photo to Share can not be empty. Tap it to set it and Share.")
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension verification: UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            billImg.image = image
            selectedImage = image
            
        }
            dismiss(animated: true)
        
    }
    
}
