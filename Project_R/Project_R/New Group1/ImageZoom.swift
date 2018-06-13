import UIKit
import Firebase

protocol  ImageZoomDelegate {
    
    func deleteImage()
}

class ImageZoom: UIViewController,UIScrollViewDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imagePassed = UIImage()
    
    var imageUrl : String = ""
    var deleteId : String?
    var delegate : ImageZoomDelegate?
    
    //    @IBOutlet weak var zoomImage: UIImageView!
    var isPresented = true
    var showDeleteIcon = true
    
    //    @IBOutlet var pinchGuester: UIPinchGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        self.imageView.sd_setImage(with: URL(string: imageUrl))
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(ImageZoom.closeTap))
        closeImageView.addGestureRecognizer(closeTap)
        closeImageView.isUserInteractionEnabled = true
        
        let deleteTap = UITapGestureRecognizer(target: self, action: #selector(ImageZoom.popAlert))
        deleteImageView.addGestureRecognizer(deleteTap)
        deleteImageView.isUserInteractionEnabled = true
        deleteImageView.isHidden = showDeleteIcon
        
        
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.scrollView.addGestureRecognizer(swipeDown)
    }
    @objc func respondToSwipeGesture (gesture : UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    @objc func closeTap() {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated..
    }
    
    @IBAction func ButtonPanGuester(_ sender: UIPinchGestureRecognizer) {
        
        
    }
    
    @objc func popAlert() {
        
        let alert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default){ action in
            
            guard let id = self.deleteId else {
                
                return
            }
            
            let db = Firestore.firestore()
            db.collection("posts").document(id).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                    ProgressHUD.showError("Delete failed.")
                } else {
                    print("Document successfully removed!")
                    
                    if let delegatexits = self.delegate {
                        
                        delegatexits.deleteImage()
                        
                    }
                    
                    self.dismiss(animated: true, completion: nil)
               
               }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

