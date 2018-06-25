//
//  verification.swift
//  Project_R
//
//  Created by CZSM G on 18/06/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//

import UIKit

class verification: UIViewController, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var addproductLbl: UILabel!
    @IBOutlet weak var billImg: UIImageView!
    @IBOutlet weak var attachBtn: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.Navigation bar title color
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 7/255, green: 192/255, blue: 141/255, alpha: 1)]
        let textFont = [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!]
        self.navigationController?.navigationBar.titleTextAttributes = textFont
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //2.Attach button corner radius
        attachBtn.layer.cornerRadius = 15
        
       tabBarController?.tabBar.isHidden = true
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func uploadBillFromFile(){
        
        let Alert: UIAlertController = UIAlertController(title: "Attach your bill", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let CamAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { ACTION in
            
        }
        
        let GallAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default){ ACTION in
            
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
    
    @IBAction func attachBill(_ sender: Any) {
             uploadBillFromFile()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)

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
