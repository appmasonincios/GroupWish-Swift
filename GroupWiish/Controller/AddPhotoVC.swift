//
//  AddPhotoVC.swift
//  GroupWiish
//
//  Created by apple on 14/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class AddPhotoVC: BottomPopupViewController {


    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
      var imagePicker = UIImagePickerController()
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Bottom popup attribute methods
    // You can override the desired method to change appearance
    
    override func getPopupHeight() -> CGFloat {
        return 180
    }
    
    @IBAction func camerabuttonaction(_ sender: Any)
    {
         openCamera()
    }
    
    @IBAction func gallerybuttonaxction(_ sender: Any)
    {
        openGallary()
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return 10
    }
    
    override func getPopupPresentDuration() -> Double {
        return 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return  true
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

}


//MARK: - UIImagePickerControllerDelegate

extension AddPhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
       
        let image = info[UIImagePickerController.InfoKey.originalImage]! as! UIImage
      
         picker.dismiss(animated: true, completion: nil)
          dismiss(animated: true, completion: nil)
        
         let imageDataDict:[String: UIImage] = ["image": image]
        
        NotificationCenter.default.post(name: Notification.Name("AddPhotoVC"), object: nil, userInfo:imageDataDict)
        
    
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
