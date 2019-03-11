//
//  PreviewViewController.swift
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
import IQKeyboardManagerSwift
import AVFoundation
import AVKit
import Kingfisher
class PreviewViewControllern: UIViewController {

    
   
    @IBOutlet weak var sendViewBtn: UIButton!

    @IBOutlet weak var grettingprofileimage: ImageViewDesign!
    @IBOutlet weak var heightofview: NSLayoutConstraint!
    @IBOutlet weak var heightoftext: NSLayoutConstraint!
    @IBOutlet weak var numberofchar: UILabel!
    @IBOutlet weak var videoTitleTF:RPFloatingPlaceholderTextField!
    @IBOutlet weak var videoMessageTextview:UITextView!
    @IBOutlet weak var selectRecipentTF:UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var gradientview: GradientView!
    var url: URL?
    var recipent_id = ""
    var greeting_id = ""
    var sendUrl = ""
    var tapped = false
    var orginalFrame = CGRect.zero
    var clickRecipient = false
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    var myGreetingsModel:MyGreetingsModelClass? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoMessageTextview.delegate = self
        gradientview.colors = topbarcolor()
        sendViewBtn.layer.cornerRadius = sendViewBtn.frame.size.height / 2
        sendViewBtn.clipsToBounds = true
        self.selectRecipentTF.text = self.myGreetingsModel?.recipient_name
        self.videoTitleTF.text = self.myGreetingsModel?.title
        sendViewBtn.setTitle("Send video", for: .normal)
        
        
      //  bedgecountapi()
    
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name:NSNotification.Name(rawValue: "SelectContactsViewController"), object: nil)

    }
    
    
//    func bedgecountapi()
//    {
//        self.getrequestcount()
//
//        let usercount = getSharedPrefrance(key:Constants.USERCOUNT)
//
//        if usercount == "" || usercount == "0"
//        {
//            self.profilebutton!.badgeString = ""
//        }
//        else
//        {
//            self.profilebutton!.badgeString = usercount
//        }
//        let unseencount = getSharedPrefrance(key:Constants.UNSEENCOUNT)
//        if unseencount == "" || unseencount == "0"
//        {
//            self.usernotification!.badgeString = ""
//        }
//        else
//        {
//            self.usernotification!.badgeString = unseencount
//        }
//    }
    
    func profileimagedisplay() {
        
        let sociallogin = getSharedPrefrance(key:Constants.social_login)
        if sociallogin == "1"
        {
            let constant = getSharedPrefrance(key:Constants.PROFILE_PIC)
            if constant != ""
            {
                let imageURL = URL(string:constant)
                grettingprofileimage.kf.setImage(with:imageURL,
                                         placeholder: UIImage(named:"image_sample.png"),
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in },
                                         completionHandler: { image, error, cacheType, imageURL in})
            }
            else
            {
                grettingprofileimage?.image = UIImage.init(named:"no-user-img")
            }
        }
        else
        {
            let constant = getSharedPrefrance(key:Constants.PROFILE_PIC)
            if constant != ""
            {
                let imageURL = URL(string:Constants.WS_ImageUrl + "/" + getSharedPrefrance(key:Constants.PROFILE_PIC))!
                grettingprofileimage.kf.setImage(with:imageURL,
                                         placeholder: UIImage(named:"image_sample.png"),
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in },
                                         completionHandler: { image, error, cacheType, imageURL in})
            }
            else
            {
                grettingprofileimage?.image = UIImage.init(named:"no-user-img")
            }
        }
    }
    
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    @objc func showSpinningWheel(_ notification: NSNotification)
    {
        if let name = notification.userInfo?["name"] as? String
        {
                if let idvalue = notification.userInfo?["id"] as? String
                {
                     self.recipent_id = idvalue
                    self.selectRecipentTF.text = name
                    self.selectRecipentTF.tag = Int(idvalue) ?? 0
                }
        }
    }
  
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        view.endEditing(true)
    }
    
    func sendSelectedContactData(_ contactID: String?, name: String?) {
        recipent_id = contactID!
        selectRecipentTF.text = name
        let str = "Send video to "
        sendViewBtn.setTitle(str + (name ?? ""), for: .normal)
    }
    
    @IBAction func selectReciepientAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectContactsViewController1") as? SelectContactsViewController1
        if let vc = vc
        {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    @IBAction func backbuttonaction(_ sender: Any)
    {
self.navigationController?.popViewController(animated:false)
    }
    
    @IBAction func playAction(_ sender: Any)
    {
        
    }
    
   
    @IBAction func sendVideoAction(_ sender: Any)
    {
        
        self.recipent_id = self.myGreetingsModel?.recipient_id ?? ""
        
        
        if videoTitleTF.text?.count == 0 || videoMessageTextview.text?.count == 0 || selectRecipentTF.text?.count == 0
        {
            self.showToast(message:"Please fill the fields..")
        }
        else
        {
           
            var parameters = [String : Any]()
       
           let video_file = sendUrl
            
                parameters = [
                    "userid":getSharedPrefrance(key:Constants.ID),
                    "recipient_id": self.recipent_id,
                    "title": self.videoTitleTF.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? "",
                    "message": videoMessageTextview.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? "",
                    "greeting_id":greeting_id,
                    "type": "free",
                    "video_file":video_file
                ]
            
            self.upload(parameter:parameters, video_url:url)
            


        }
        
        
    }
    

    func upload(parameter:[String:Any],video_url:URL?)
    {
        let url = "\(Constants.LIVEURL)\(Constants.send_final_video)"
        
        executePOST(view: self.view, path:url, parameter:parameter){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC
                if let tabVC = tabVC
                {
                    self.present(tabVC, animated: false)
                    {
                       // self.showToastWithMessage(message:"Uploaded Successfully", onVc:(UIApplication.shared.keyWindow?.rootViewController)!, type:"4")
                        NotificationCenter.default.post(name: Notification.Name("showsimplemessage"), object: nil)
                        //post the notification
                    }
                }
            }
            else
            {
                //self.showToast(message:response["errors"].string ?? "")
            }
        }
}
}


extension PreviewViewControllern:UITextViewDelegate
{
    
    func textView(_ textView:UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        
        self.heightoftext.constant = CGFloat(textView.numberOfLines() * 21) + 10
        
        self.numberofchar.text = "\(numberOfChars)" + "/160"
        
        
        return numberOfChars < 160;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            heightoftext.constant = 40
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

