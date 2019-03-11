//
//  ProfileViewController.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
import ImagePicker
import Lightbox
import Kingfisher
import YKPhotoCircleCrop
import Kingfisher
import ViewAnimator
import PopItUp
class ProfileViewController: UIViewController,ImagePickerDelegate {
  

    var profileimage:Bool = false
    @IBOutlet weak var photoImageView: ImageViewDesign!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var nameTF: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var emailTF: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var mobileTF: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var locationTF: SkyFloatingLabelTextFieldWithIcon!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       savesharedprefrence(key:Constants.menunumber, value:"0")
       NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: Notification.Name(rawValue: "notificationName"), object: nil)
    
        self.namelabel.text = getSharedPrefrance(key:Constants.USERNAME)
        executeGET(view: self.view, path: Constants.LIVEURL + Constants.user_details + "?userid=" + getSharedPrefrance(key:Constants.ID)){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                let sociallogin = getSharedPrefrance(key:Constants.social_login)
                var imageURL:URL? = nil
                if sociallogin == "1"
                {
                    let constant = getSharedPrefrance(key:Constants.PROFILE_PIC)
                     imageURL = URL(string:constant)
                }
                else
                {
                    imageURL = URL(string:Constants.WS_ImageUrl + "/" + response["data"]["profile_pic"].stringValue)!
                }
            
                self.photoImageView.kf.indicatorType = .activity
                self.photoImageView.kf.setImage(with: imageURL)
                self.emailTF.text = response["data"]["email"].stringValue
                self.nameTF.text = response["data"]["username"].stringValue
                self.locationTF.text = response["data"]["location"].stringValue
                self.mobileTF.text = response["data"]["mobile"].stringValue
                self.passwordTF.text = response["data"]["password"].stringValue
                self.passwordTF.isSecureTextEntry = true
            }
            else
            {
               //self.showToast(message:response["errors"].string ?? "")
            }
    
        }

    }
    
    // handle notification
    @objc func showSpinningWheel(_ notification:Notification)
    {
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary?
        {
            if let id = dict["image"] as? UIImage
            {
               self.profileimage = true
                photoImageView.image = id
            }
        }
    }
    
    func circleCropDidCancel()
    {
        print("User canceled the crop flow")
    }
    func circleCropDidCropImage(_ image: UIImage)
    {
    }
    @objc func show(notification: NSNotification)
    {
        self.photoImageView.image = notification.userInfo?["image"] as? UIImage
    }
    @IBAction func backbuttonaction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated:true)
    }
    @IBAction func profilebuttonaction(_ sender: Any)
    {
        presentPopup(AddProfilePicVC(),
                     animated: true,
                     backgroundStyle: .blur(.dark), // present the popup with a blur effect has background
            constraints: [.leading(16), .trailing(16),.height(254)], // fix leading edge and the width
            transitioning: .slide(.left), // the popup come and goes from the left side of the screen
            autoDismiss: false, // when touching outside the popup bound it is not dismissed
            completion: nil)
      
    }
    
    @IBAction func updatebuttonaction(_ sender: Any)
    {
        let name:String = (self.nameTF?.text)!
        let email:String = (self.emailTF?.text)!
        let password:String = (self.passwordTF?.text)!
        let mobile:String = (self.mobileTF?.text)!
        
        if profileimage == true
        {
            let parameter:[String:Any] = [
                "email": email,
                "password":password,
                "username":name,
                "mobile":mobile,
                "userid":getSharedPrefrance(key:Constants.ID)
            ]
            saveimage(image: self.photoImageView.image!, parameter:parameter)
        }
        else
        {
            let parameter:[String:Any] = [
                "email": email,
                "password":password,
                "username":name,
                "mobile":mobile,
                "userid":getSharedPrefrance(key:Constants.ID),"profile_pic":""
            ]
        
            executePOST(view: self.view, path: Constants.LIVEURL + Constants.update_user, parameter: parameter){ response in
                let status = response["status"].int
                if(status == Constants.SUCCESS_CODE)
                {
                    self.showToast(message:"Successful updated")
                    savesharedprefrence(key:Constants.USERNAME, value:response["description"]["username"].string ?? "")
                    savesharedprefrence(key:Constants.EMAIL, value:response["description"]["email"].string ?? "")
                    savesharedprefrence(key:Constants.MOBILE, value:response["description"]["mobile"].string ?? "")
                    savesharedprefrence(key:Constants.PROFILE_PIC, value:response["description"]["profile_pic"].string ?? "")
                }
                else
                {
                    //self.showToast(message:response["errors"].string ?? "")
                }
            }
        }
    }
    
    
    func saveimage(image:UIImage,parameter:[String:Any])
    {
        let headers = [
            "Authorization": getSharedPrefrance(key:Constants.TOKEN)]
        
        let url = Constants.LIVEURL + Constants.update_user
        self.showLoader(view: self.view)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameter
            {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let imageData = UIImage.jpegData(image)(compressionQuality:0.4)
            {
                let r = arc4random()
                let str = "screenshot"+String(r)+".jpg"
                
                let parameterName = "profile_pic"
                multipartFormData.append(imageData, withName:parameterName, fileName:str, mimeType: "image/jpeg")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers:headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    self.hideLoader(view: self.view)
                    
                    let Json = (response.result.value as AnyObject?)
                    
                    if let httpStatus = response.response , httpStatus.statusCode == 200 {
                        if response.result.isSuccess
                        {
                            if let jsonResult = Json as? Dictionary<String, AnyObject>
                            {
                                if let responeCode = jsonResult["status"] as? Int {
                                    if  responeCode == Constants.SUCCESS_CODE
                                    {
                                           self.showToast(message:"Successful updated")
                                        if let description = jsonResult["description"] as? Dictionary<String,String>
                                        {
                                             savesharedprefrence(key:Constants.USERNAME, value:description["username"] ?? "")
                                             savesharedprefrence(key:Constants.EMAIL, value:description["email"] ?? "")
                                             savesharedprefrence(key:Constants.MOBILE, value:description["mobile"] ?? "")
                                            let sociallogin = getSharedPrefrance(key:Constants.social_login)
                                            if sociallogin == "1"
                                            {
                                               savesharedprefrence(key:Constants.PROFILE_PIC, value:description["full_profile_path"] ?? "")
                                            }
                                            else
                                            {
                                                if let profileimage = description["profile_pic"]
                                                {
                                                    let  constant:String = Constants.WS_ImageUrl + "/" + profileimage
                                                    savesharedprefrence(key:Constants.PROFILE_PIC, value:constant)
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        self.showToast(message:jsonResult["message"] as? String ?? "")
                                    }
                                }
                                else
                                {
                                    self.hideLoader(view: self.view)
                                }
                                
                            } else {
                                print("Data is not in proper format")
                                self.hideLoader(view: self.view)
                            }
                        }
                        else
                        {
                            self.showToast(message:"something went wrong")
                            self.hideLoader(view: self.view)
                        }
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - ImagePickerDelegate
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage])
    {
        guard images.count > 0 else { return }
        let lightboxImages = images.map
        {
            return LightboxImage(image: $0)
        }
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage])
    {
        profileimage = true
        self.photoImageView.image = images[0]
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}
    
    


