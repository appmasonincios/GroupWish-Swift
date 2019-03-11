//
//  AddVideoVC.swift
//  GroupWiish
//
//  Created by apple on 14/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import Alamofire
import ViewAnimator
import PopItUp
import MobileCoreServices
import CoreFoundation
import AVFoundation
import DYBadgeButton
class AddVideoVC:UIViewController
{
    @IBOutlet weak var profilebutton: DYBadgeButton!
    @IBOutlet weak var usernotification: DYBadgeButton!
    @IBOutlet weak var sendAction: UIButton!
    @IBOutlet weak var friendBtn: UIButton!
    @IBOutlet weak var plyBtnVideo: UIButton!
    @IBOutlet weak var addVideoBack: UIImageView!
    @IBOutlet weak var addVideoImageView: ImageViewDesign!
    @IBOutlet weak var addVideoLbl: UILabel!
    @IBOutlet weak var videoPicker: UIButton!
    @IBOutlet weak var editActionBtn: UIButton!
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var profileimage: ImageViewDesign!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var chooseFriendTF: UITextField!
    @IBOutlet weak var countlabel: UILabel!
    @IBOutlet weak var heightoftext: NSLayoutConstraint!
    @IBOutlet weak var messageTextView:UITextView!
    var video_url: URL?
    var imagePicker = UIImagePickerController()
    var videoChoosen:Bool = false
    var recipent_id = ""
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

        
        messageTextView.text = "Message"
        messageTextView.textColor = UIColor.lightGray
        messageTextView.delegate = self
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(openCamera), name: Notification.Name(Constants.openCamera1), object: nil)
        nc.addObserver(self, selector: #selector(openGallary), name: Notification.Name(Constants.openGallary), object: nil)
         nc.addObserver(self, selector: #selector(methodOfReceivedNotification(notification:)), name: Notification.Name(Constants.friendnotification), object: nil)
       self.profileimagedisplay()
        gradientView.colors = topbarcolor()
       
    self.chooseFriendTF.isUserInteractionEnabled = false
          self.friendBtn.setTitleColor(UIColor.lightGray, for:.normal)
        
       KanvasSDK.initialize(withClientID:Constants.KanvasSDKClientID, signature:Constants.KanvasSDKsignature)
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        bedgecountapi()
    }
    
    
    @IBAction func profilebuttonaclicked(_ sender: Any)
    {
        self.profileclicked()
    }
    
    @IBAction func notificationbuttonaction(_ sender: Any)
    {
        self.requestViewController()
    }
    
    func bedgecountapi()
    {
        self.getrequestcount()
        
        let usercount = getSharedPrefrance(key:Constants.USERCOUNT)
        
        if usercount == "" || usercount == "0"
        {
            self.profilebutton!.badgeString = ""
        }
        else
        {
            self.profilebutton!.badgeString = usercount
        }
        let unseencount = getSharedPrefrance(key:Constants.UNSEENCOUNT)
        if unseencount == "" || unseencount == "0"
        {
            self.usernotification!.badgeString = ""
        }
        else
        {
            self.usernotification!.badgeString = unseencount
        }
    }
    
    func profileimagedisplay()
    {
        if  let userprofile  = self.userprofilespecialmethod()
        {
            let imageURL = URL(string:userprofile)
            self.profileimage.kf.setImage(with:imageURL,
                                          placeholder: UIImage(named:"no-user-img.png"),
                                          options: [.transition(ImageTransition.fade(1))],
                                          progressBlock: { receivedSize, totalSize in },
                                          completionHandler: { image, error, cacheType, imageURL in})
        }
    }
    
    
    @IBAction func reqestbuttonaction(_ sender: Any)
    {
        self.requestViewController()
    }
    
    @IBAction func profilebuttonaction(_ sender: Any)
    {
        self.profileclicked()
    }
    

    
    override func viewDidLayoutSubviews()
    {
    }
    
    @IBAction func sendwishbuttonaction(_ sender: Any)
    {
        if videoChoosen == true
        {
            if self.titleTF.text != "" && self.messageTextView.text != "" && self.chooseFriendTF.text != ""
            {
             
                var parameters = [String : Any]()
                
                let title:String = self.titleTF.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
                let message:String = self.messageTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
                let object = getSharedPrefrance(key:Constants.ID)
                    parameters = [
                        "userid": object,
                        "friend_id": recipent_id,
                        "title":title,
                        "message":message
                    ]
               upload(parameter:parameters)
            }
            else
            {
                self.showToast(message:"Please fill all the fields..")
            }
        }
        else
        {
            self.showToast(message:"Wish Video required..")

        }
        
    }
    
    @IBAction func choosebuttonaction(_ sender: Any)
    {
        let vc:ChooseFriendVC = self.storyboard?.instantiateViewController(withIdentifier:"ChooseFriendVC") as! ChooseFriendVC
        self.navigationController?.pushViewController(vc, animated:false)
        
    }
    
    func upload(parameter:[String:Any])
    {
        let url = Constants.LIVEURL + Constants.send_video_user
        
        let headers = [
            "Authorization": getSharedPrefrance(key:Constants.TOKEN)]
        
        self.showLoader(view: self.view)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameter
            {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let imageData = self.video_url
            {
              //  let r = arc4random()
                //video.mp4
                 let ext:String = "video."
                let str:String = ext + (self.video_url?.pathExtension)!
            
            
                let parameterName = "video_file"
                multipartFormData.append(imageData, withName:parameterName, fileName:str, mimeType: "video/mp4")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers:headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    self.hideLoader(view: self.view)
                    
                    let Json = (response.result.value as AnyObject?)
                    
                    if let httpStatus = response.response , httpStatus.statusCode == 200 {
                        if response.result.isSuccess {
                        
                            if let jsonResult = Json as? Dictionary<String, AnyObject> {
                                print(jsonResult)
                                if let responeCode = jsonResult["status"] as? Int
                                {
                                    if  responeCode == Constants.SUCCESS_CODE
                                    {
                                        self.showToast(message:"Uploaded Successfully")
                                        
                                        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC
                                        if let tabVC = tabVC
                                        {
                                            self.present(tabVC, animated: false)
                                            {
                                                self.showToastWithMessage(message:"Sent Successfully", onVc:(UIApplication.shared.keyWindow?.rootViewController)!, type:"2")
                                            }
                                        }
                                    }
                                    else
                                    {
                                        self.showToast(message:jsonResult["description"] as? String ?? "")
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
                        }  else {
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
    
   
    
    @IBAction func addvideobuttonaction(_ sender: Any)
    {
        
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "AddSelectVideoVC") as? AddSelectVideoVC else { return }
        
        popupVC.popupDelegate = self
        present(popupVC, animated: true, completion: nil)
        
        
    }
    
    @IBAction func backbuttonaction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated:false)
    }
    
    @objc func openCamera(){
        
        let vc = KVNCameraViewController.verified()
        vc?.delegate = self
        vc?.settings.enableAssetPicker = false
        vc?.settings.enableCameraMode = true
        vc?.settings.enableGrid = false
        vc?.settings.enableGifMode = false
        vc?.settings.enableStopMotion = false
        vc?.settings.enableFilters = false
        vc?.settings.enableVideoMode = true
        vc?.maxVideoDuration = 15
    
        present(vc!, animated: true)
        
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification)
    {
        if let id = notification.userInfo?["id"] as? String
        {
            if let name = notification.userInfo?["username"] as? String
            {
                self.chooseFriendTF.text = name
                recipent_id = id
                self.friendBtn.setTitle(name, for:.normal)
                self.friendBtn.setTitleColor(UIColor.black, for:.normal)
                let str = "Send wish to "
                self.sendAction.setTitle(str + name, for:.normal)
            }
        }
        else
        {
            
        }

      

    }
    //MARK: - Choose image from camera roll
    
    @objc func openGallary()
    {
        
        let videoPicker = UIImagePickerController()
        
        videoPicker.delegate = self
        videoPicker.modalPresentationStyle = .currentContext
        videoPicker.mediaTypes = [
            kUTTypeMovie as String,
            kUTTypeAVIMovie as String,
            kUTTypeVideo as String,
            kUTTypeMPEG4 as String
        ]
        videoPicker.videoQuality = .typeHigh
        videoPicker.allowsEditing = true
        videoPicker.videoMaximumDuration = 15
        dismiss(animated: true)
        present(videoPicker, animated: true)
        //openGallary Notification
        
    }
}

extension AddVideoVC: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}




extension AddVideoVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate,KVNCameraViewControllerDelegate,KVNEditViewControllerDelegate
{
    func presentEdit(_ url: URL?)
    {
        let viewController = KVNEditViewController.verified()
        viewController?.delegate = self
        viewController?.url = url
        present(viewController!, animated: true)
    }
    
    
    func cameraViewController(_ cameraViewController: KVNCameraViewController!, didFinishWith image: UIImage!) {
        // Do Nothing
        
        
        
    }
    
    func cameraViewController(_ cameraViewController: KVNCameraViewController!, didFinishWithVideo fileURL: URL!)
    {
        cameraViewController.dismiss(animated:true, completion:{
                self.videoChoosen = true
                self.video_url = fileURL
                self.addVideoBack.isHidden = true
                self.addVideoImageView.isHidden = true
                self.addVideoLbl.isHidden = true
                self.videoPicker.isHidden = true
                self.editActionBtn.isHidden = false
                self.plyBtnVideo.isHidden = false
                
                if fileURL != nil
                {
                    self.pickedImageView.image = self.thumbnailImageFor(fileUrl:fileURL)
                }
                else
                {
                    // self.videoplayercontainerview.isHidden = true
                }
        })
        
          self.dismiss(animated:false, completion:nil)

    }
    
    func cameraViewController(_ cameraViewController: KVNCameraViewController!, backButtonPressed sender: Any!)
    {
        cameraViewController.dismiss(animated:true, completion:nil)
        // Do Nothing
    }
    
    func cameraViewController(_ cameraViewController: KVNCameraViewController!, didFinishWithGifURL fileURL: URL!) {
        // Do Nothing
    }
    
    func cameraViewController(_ cameraViewController: KVNCameraViewController!, willDismiss sender: Any!)
    {
        
        cameraViewController.dismiss(animated:true, completion:nil)
    }
    
    func editViewController(_ viewController: KVNEditViewController!, backButtonPressed sender: Any!) {
        
        
        viewController.dismiss(animated:true, completion:nil)
    }
    
    func editViewController(_ viewController: KVNEditViewController!, createdImage image: KVNOutputImage!) {
        // Do Nothing
    }
    
    func editViewController(_ viewController: KVNEditViewController!, createdVideo videoDataURL: URL!) {
        dismiss(animated: true) {
            
            self.videoChoosen = true
            self.video_url = videoDataURL
            self.addVideoBack.isHidden = true
            self.addVideoImageView.isHidden = true
            self.addVideoLbl.isHidden = true
            self.videoPicker.isHidden = true
            self.editActionBtn.isHidden = false
            self.plyBtnVideo.isHidden = false

            if videoDataURL != nil
            {
                self.pickedImageView.image = self.thumbnailImageFor(fileUrl:videoDataURL)
            }
            else
            {
               // self.videoplayercontainerview.isHidden = true
            }
        }
    }
    
    func editViewController(_ viewController: KVNEditViewController!, createdGif gifDataURL: URL!) {
        // Do Nothing
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        var asset: AVURLAsset? = nil
        if let videoURL = videoURL {
            asset = AVURLAsset(url: videoURL, options: nil)
        }
        var durationInSeconds: TimeInterval = 0.0
        
        if asset != nil
        {
            durationInSeconds = CMTimeGetSeconds((asset?.duration)!)
            if durationInSeconds <= 15
            {
                picker.dismiss(animated:true)
                {
                    self.presentEdit(videoURL)
                }
            }
            else
            {
                if picker.sourceType == UIImagePickerController.SourceType.camera
                {
                    let suggestionsAlert = UIAlertController(title: "Alert", message: "Only upto 15 seconds duration is allowed.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.dismiss(animated: true) {
                            let videoPicker = UIImagePickerController()
                            videoPicker.delegate = self
                            videoPicker.modalPresentationStyle = .currentContext
                            videoPicker.mediaTypes = [
                                kUTTypeMovie as String,
                                kUTTypeAVIMovie as String,
                                kUTTypeVideo as String,
                                kUTTypeMPEG4 as String
                            ]
                            videoPicker.videoQuality = .typeHigh
                            videoPicker.allowsEditing = true
                            self.present(videoPicker, animated: true)
                        }
                    })
                    suggestionsAlert.addAction(okAction)
                    present(suggestionsAlert, animated: true)
                }
                else
                {
                    picker.dismiss(animated: true) {
                        self.presentEdit(videoURL)
                    }
                }
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated:true, completion:nil)
    }

}



extension AddVideoVC:UITextViewDelegate
{
    
    func textView(_ textView:UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        
        self.heightoftext.constant = CGFloat(textView.numberOfLines() * 21) + 20
        
        self.countlabel.text = "\(numberOfChars)" + "/160"
        
        return numberOfChars < 160;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray
        {
            textView.text = nil
            heightoftext.constant = 46
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    
    
}
