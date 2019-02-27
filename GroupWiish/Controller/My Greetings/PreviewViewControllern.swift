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

class PreviewViewControllern: UIViewController {

    
   
    @IBOutlet weak var sendViewBtn: UIButton!
  
   
    @IBOutlet weak var videoTitleTF: RPFloatingPlaceholderTextField!
    @IBOutlet weak var videoMessageTF: RPFloatingPlaceholderTextField!
    @IBOutlet weak var selectRecipentTF: RPFloatingPlaceholderTextField!
 @IBOutlet weak var videoView: UIView!
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    @IBOutlet weak var gradientview: GradientView!
    var url: URL?
    var recipent_id = ""
    var greeting_id = ""
    var sendUrl = ""
    var tapped = false
    var orginalFrame = CGRect.zero
    var clickRecipient = false
    override func viewDidLoad() {
        super.viewDidLoad()

        gradientview.colors = topbarcolor()
      
        sendViewBtn.layer.cornerRadius = sendViewBtn.frame.size.height / 2
        sendViewBtn.clipsToBounds = true
       

        sendViewBtn.setTitle("Send video", for: .normal)
        
    
        if let url = URL(string: "\(Constants.WS_VideoUrl)/\(sendUrl)")
                {
                    player = AVPlayer(url:url)
                    avpController.player = player
                    avpController.videoGravity = AVLayerVideoGravity(rawValue: AVLayerVideoGravity.resizeAspect.rawValue)
                    self.addChild(avpController)
                    avpController.view.frame = videoView.frame
                    self.videoView.addSubview(avpController.view)
                    videoView.layer.masksToBounds = true
                }
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name:NSNotification.Name(rawValue: "SelectContactsViewController"), object: nil)

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
        
        
        if videoTitleTF.text?.count == 0 || videoMessageTF.text?.count == 0 || selectRecipentTF.text?.count == 0
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
                    "message": videoMessageTF.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? "",
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
                        self.showToastWithMessage(message:"Uploaded Successfully", onVc:(UIApplication.shared.keyWindow?.rootViewController)!, type:"4")
                    }
                }
            }
            else
            {
                self.showToast(message:response["errors"].string ?? "")
            }
        }
}
}
