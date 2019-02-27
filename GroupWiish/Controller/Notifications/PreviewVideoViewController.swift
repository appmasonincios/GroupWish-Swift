//
//  PreviewVideoViewController.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
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
import AVKit
import DYBadgeButton
class PreviewVideoViewController: UIViewController
{

    @IBOutlet weak var usernotification: DYBadgeButton!

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var countlabel: UILabel!
    @IBOutlet weak var heightoftext: NSLayoutConstraint!
    @IBOutlet weak var messageTextView:UITextView!
    @IBOutlet weak var videoView: UIView!
    var videoDataURL: URL?
    var greeting_id:String? = nil
    var friend_id:String? = nil
    
    
    @IBOutlet weak var profileimage: ImageViewDesign!
     var imagePicker = UIImagePickerController()
    @IBOutlet weak var gradientview: GradientView!
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        messageTextView.text = "Message"
        messageTextView.textColor = UIColor.lightGray
        messageTextView.delegate = self
        gradientview.colors = topbarcolor()
        profileimagedisplay()
        let url = videoDataURL
        player = AVPlayer(url: url!)
        avpController.player = player
        avpController.videoGravity = AVLayerVideoGravity(rawValue: AVLayerVideoGravity.resizeAspect.rawValue)
        self.addChild(avpController)
        avpController.view.frame = videoView.frame
        self.videoView.addSubview(avpController.view)
        videoView.layer.masksToBounds = true
        
        bedgecountapi()
        // Do any additional setup after loading the view.
    }
    
    func bedgecountapi()
    {
        self.getrequestcount()
       
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

    
    func profileimagedisplay() {
        
        let sociallogin = getSharedPrefrance(key:Constants.social_login)
        if sociallogin == "1"
        {
            let constant = getSharedPrefrance(key:Constants.PROFILE_PIC)
            if constant != ""
            {
                let imageURL = URL(string:constant)
                profileimage.kf.setImage(with:imageURL,
                                         placeholder: UIImage(named:"image_sample.png"),
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in },
                                         completionHandler: { image, error, cacheType, imageURL in})
            }
            else
            {
                profileimage?.image = UIImage.init(named:"no-user-img")
            }
        }
        else
        {
            let constant = getSharedPrefrance(key:Constants.PROFILE_PIC)
            if constant != ""
            {
                let imageURL = URL(string:Constants.WS_ImageUrl + "/" + getSharedPrefrance(key:Constants.PROFILE_PIC))!
                profileimage.kf.setImage(with:imageURL,
                                         placeholder: UIImage(named:"image_sample.png"),
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in },
                                         completionHandler: { image, error, cacheType, imageURL in})
            }
            else
            {
                profileimage?.image = UIImage.init(named:"no-user-img")
            }
        }
    }
    
    

    @IBAction func sharebuttonaction(_ sender: Any)
    {
        
        if self.titleTF.text?.isEmpty == true
        {
            self.showToast(message:"Please Enter Title")
        }
        else if self.messageTextView.text.isEmpty == true
        {
            self.showToast(message:"Please Enter Message")
        }
        else if self.videoDataURL?.absoluteString.isEmpty == true
        {
             self.showToast(message:"Please Add Video")
        }
        else
        {
            var parameters = [String:Any]()
            parameters["userid"] = getSharedPrefrance(key:Constants.ID)
            parameters["friend_id"] = self.friend_id
            parameters["greeting_id"] = self.greeting_id
            parameters["title"] = self.titleTF.text
            parameters["message"] = self.messageTextView.text
            parameters["apptype"] = "free"
           // WS_Send_to_host
            upload(parameter:parameters, video_url:videoDataURL)
            
        }
    }
    
    func upload(parameter:[String:Any],video_url:URL?)
    {//UIImage.jpegData(image)(compressionQuality:0.4)
        let url = Constants.LIVEURL + Constants.send_video_host
        
        let headers = [
            "Authorization": getSharedPrefrance(key:Constants.TOKEN)]
        
        self.showLoader(view: self.view)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameter
            {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let imageData = video_url
            {
                //  let r = arc4random()
                //video.mp4
                let ext:String = "video."
                let str:String = ext + (video_url?.pathExtension)!
                
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
                                                self.showToastWithMessage(message:"Sent Successfully", onVc:(UIApplication.shared.keyWindow?.rootViewController)!, type:"4")
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
    
    @IBAction func backbuttonaction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated:false)
    }
    
}


extension PreviewVideoViewController:UITextViewDelegate
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


