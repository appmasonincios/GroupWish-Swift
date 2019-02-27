//
//  AddProfilePicVC.swift
//  GroupWiish
//
//  Created by apple on 25/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import YKPhotoCircleCrop
class AddProfilePicVC: UIViewController,YKCircleCropViewControllerDelegate {
  var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "g"), object: nil)
        // Do any additional setup after loading the view.
    }

    
    
    
    
    @IBAction func chooseGalleryAction(_ sender: Any)
    {
        
        openGallary()
        //gallery
       
        
    }
    
    @IBAction func camaraVideoAction(_ sender: Any)
    {
        openCamera()
//        let nc = NotificationCenter.default
//        nc.post(name: Notification.Name("c"), object: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any)
    {
        self.dismiss(animated:true, completion:nil)
    }
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

  
    // MARK: - YKCircleCropViewControllerDelegate
    func circleCropDidCancel()
    {
        print("User canceled the crop flow")
    }
    
    func circleCropDidCropImage(_ image: UIImage)
    {
        let imageDataDict:[String: UIImage] = ["image": image]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: imageDataDict)
        dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - UIImagePickerControllerDelegate

extension AddProfilePicVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        let image = info[UIImagePickerController.InfoKey.originalImage]! as! UIImage
        picker.dismiss(animated: true, completion: nil)
        let circleCropController = YKCircleCropViewController()
         circleCropController.image = image
        circleCropController.delegate = self
        present(circleCropController, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
