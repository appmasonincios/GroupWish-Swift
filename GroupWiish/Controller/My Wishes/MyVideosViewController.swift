//
//  MyVideosViewController.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import SideMenu
import Kingfisher
import SwiftyJSON
import Alamofire
import ViewAnimator
import AVFoundation
import AVKit
import DYBadgeButton
class MyVideosViewController: UIViewController {
    
    @IBOutlet weak var usernotification: DYBadgeButton!
    @IBOutlet weak var profilebutton: DYBadgeButton!
    private let image = UIImage(named: "receivedgreetings-inactive")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = ""
    private let bottomMessage = "No Videos Found"

    @IBOutlet weak var searchView: GradientView!
    @IBOutlet var searchtextfield: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
     private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    @IBOutlet weak var get_final_videosBG: UIView!
     var myVideosdata = [MyVideosModelClass]()
     var searchedArray = [MyVideosModelClass]()
     var booleancheck:Bool = false
    @IBOutlet weak var get_final_videosview: ViewDesign!
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.searchtextfield.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        settingsui()
        userNotificationCenter()
       
    }

    override func viewWillAppear(_ animated: Bool)
    {
        bedgecountapi()
        profileimagedisplay()
        savesharedprefrence(key:Constants.TABTYPE, value:"2")
        self.get_final_videos()
        
        self.usernotification.badgeFont = UIFont(name: "Helvetica Neue", size: 15.0)!
        self.usernotification.badgeColor = UIColor.red
        self.profilebutton.badgeFont = UIFont(name: "Helvetica Neue", size: 15.0)!
        self.profilebutton.badgeColor = UIColor.red
        self.profilebutton.badgeString = "0"
        self.usernotification.badgeString = "0"
        
    }

    func setupEmptyBackgroundView()
    {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.tableview.backgroundView = emptyBackgroundView
    }
    
    
    func bedgecountapi()
    {
        
        
        self.getrequestcount()
        let usercount = getSharedPrefrance(key:Constants.USERCOUNT)
        
        if usercount == "" || usercount == "0"
        {
            self.profilebutton!.badgeString = "0"
        }
        else
        {
            self.profilebutton!.badgeString = usercount
        }
        let unseencount = getSharedPrefrance(key:Constants.UNSEENCOUNT)
        if unseencount == "" || unseencount == "0"
        {
            self.usernotification!.badgeString = "0"
        }
        else
        {
            self.usernotification!.badgeString = unseencount
        }
    }
    
    
    
    @objc func searchRecordsAsPerText(_ textfield:UITextField)
    {
        searchedArray.removeAll()
        if textfield.text?.characters.count != 0
        {
            for strCountry in self.myVideosdata
            {
                let str = strCountry.friend_name
                let range = str?.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                
                if range != nil
                {
                    searchedArray.append(strCountry)
                }
            }
        } else {
            searchedArray = self.myVideosdata
        }
        
        tableview.reloadData()
    }
    func settingsui()
    {
        setupEmptyBackgroundView()
        gradientView.colors = topbarcolor()
        searchView.colors = topbarcolor()
        setupSideMenu()
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    @IBAction func searchbuttonaction(_ sender: Any)
    {
        booleancheck = true
        self.searchView.isHidden = false
    }
    @IBAction func cancelbuttonaction(_ sender: Any)
    {
        booleancheck = false
        self.searchView.isHidden = true
        self.tableview.reloadData()
    }
    
    
    func userNotificationCenter()
    {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name("ULO2"), object: nil)
        nc.addObserver(self, selector: #selector(userLoggedIn1), name: Notification.Name("UserLoggedOut2"), object: nil)
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
    @objc func userLoggedIn()
    {
        dismiss(animated:true, completion:nil)
        presentPopup(TestPopupViewController(),
                     animated: true,
                     backgroundStyle: .blur(.dark), // present the popup with a blur effect has background
            constraints: [.leading(16), .trailing(16),.height(250)], // fix leading edge and the width
            transitioning: .slide(.left), // the popup come and goes from the left side of the screen
            autoDismiss: false, // when touching outside the popup bound it is not dismissed
            completion: nil)
    }
    
    
    @objc func userLoggedIn1()
    {
        savesharedprefrence(key:"loginsession", value:"false")
        logout()
        let sc:SplashScreenViewController = self.storyboard?.instantiateViewController(withIdentifier:"SplashScreenViewController") as! SplashScreenViewController
        self.presentPopup(sc, animated:false)
    }
    

    @IBAction func profilebuttonaclicked(_ sender: Any)
    {
        profileclicked()
    }
    
    @IBAction func requestbuttonaction(_ sender: Any)
    {
        self.requestViewController()
    }

    func get_final_videos()
    {
        
        executeGET(view: self.view, path: Constants.LIVEURL + Constants.get_final_videos + "?userid=" + getSharedPrefrance(key:Constants.ID)){ response in
            let status = response["description"].string
            if(status == "success")
            {
                self.myVideosdata.removeAll()
            
                for store in response["data"].arrayValue
                {
                    self.myVideosdata.append(MyVideosModelClass(json:store.dictionaryObject!)!)
                }
                
                self.tableview.reloadData()
                UIView.animate(views: self.tableview.visibleCells, animations: self.animations, completion: {
                })
            }
            else
            {
                self.showToast(message:response["errors"].string ?? "")
            }
        }
        
    }
    
    func setupSideMenu()
    {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = CGFloat(0)
    }
}
extension MyVideosViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if booleancheck == false
        {
            if myVideosdata.count == 0
            {
                tableView.separatorStyle = .none
                tableView.backgroundView?.isHidden = false
            } else
            {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView?.isHidden = true
            }
            return myVideosdata.count
        }
        else
        {
            if searchedArray.count == 0
            {
                tableView.separatorStyle = .none
                tableView.backgroundView?.isHidden = false
            }
            else
            {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView?.isHidden = true
            }
            
            return searchedArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyVideoTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyVideoTableViewCell", for:indexPath) as! MyVideoTableViewCell
        var notificationdataone:MyVideosModelClass? = nil
        
        if  booleancheck == false
        {
            notificationdataone = self.myVideosdata[indexPath.row]
        }
        else
        {
            notificationdataone = self.searchedArray[indexPath.row]
        }
    
        if let image = notificationdataone?.friend_pic
        {
            let imageURL = URL(string:Constants.WS_ImageUrl + "/" + image)!
            cell.profileimage.kf.indicatorType = .activity
            cell.profileimage.kf.setImage(with:imageURL)
        }
        else
        {
            cell.profileimage.image = UIImage.init(named:"no-user-img")
        }
        
        
        if let mainimageURL = notificationdataone?.thumb_image
        {
    
            let url = URL(string:Constants.WS_ImageUrl + "/" + mainimageURL)
            cell.thumb_image.kf.setImage(with: url,
                                       placeholder: UIImage(named:"image_sample.png"),
                                       options: [.transition(ImageTransition.fade(1))],
                                       progressBlock: { receivedSize, totalSize in },
                                       completionHandler: { image, error, cacheType, imageURL in})
        }
        else
        {
           cell.thumb_image.image = UIImage.init(named:"placeHolder.png")
        }
        cell.friend_name.text = notificationdataone?.friend_name
        cell.title.text = notificationdataone?.title
        cell.message.text = notificationdataone?.message
        cell.videobutton.tag = indexPath.row
       
        cell.sharebutton.accessibilityHint = notificationdataone?.video_name
        cell.videobutton.addTarget(self, action:#selector(self.sayAction), for: .touchUpInside)
        cell.videobutton.accessibilityHint = notificationdataone?.video_name
        
        cell.datelabel.text = self.convertDateFormater((notificationdataone?.datetime)!)

        cell.sharebutton.tag = indexPath.row
         cell.sharebutton.addTarget(self, action:#selector(self.sharebuttonAction), for: .touchUpInside)
        
        cell.downloadbutton.accessibilityHint = notificationdataone?.video_name
        cell.downloadbutton.tag = indexPath.row
        cell.downloadbutton.addTarget(self, action:#selector(downloadbuttonaction(_:)), for:.touchUpInside)
        
        
        if notificationdataone?.thank_card == 1
        {
            cell.replayview.isHidden = true
        }
        else
        {
             cell.replayview.isHidden = false
        }
        
        cell.replaybuttonaction.tag = indexPath.row
       cell.replaybuttonaction.addTarget(self, action:#selector(replaybuttonaction(_:)), for:.touchUpInside)
        
    
        return cell
    }
    
    
    @objc func replaybuttonaction(_ sender: UIButton?)
    {
       
        let selectThankYouCardVC:SelectThankYouCardVC = self.storyboard?.instantiateViewController(withIdentifier:"SelectThankYouCardVC") as! SelectThankYouCardVC
        if booleancheck == false
        {
            selectThankYouCardVC.myVideosModelClass = self.myVideosdata[(sender?.tag)!]
        }
        else
        {
            selectThankYouCardVC.myVideosModelClass = self.searchedArray[(sender?.tag)!]
        }
        self.navigationController?.pushViewController(selectThankYouCardVC, animated:false)
    }
    
    @objc func downloadbuttonaction(_ sender: UIButton?)
    {
        if let url = URL(string: "\(Constants.WS_VideoUrl)/\(sender?.accessibilityHint ?? "")")
        {
            let path:String = url.absoluteString
            let videourl:String = path
            savesharedprefrence(key:"keyurl", value:videourl)
        }
        
        presentPopup(DownloadVC(),
                     animated: true,
                     backgroundStyle: .blur(.dark), // present the popup with a blur effect has background
            constraints: [.leading(16), .trailing(16),.height(206)], // fix leading edge and the width
            transitioning: .slide(.right), // the popup come and goes from the left side of the screen
            autoDismiss: false, // when touching outside the popup bound it is not dismissed
            completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 360
    }
    
    @objc  func sayAction(_ sender: UIButton?)
    {
        var player: AVPlayer? = nil
        if let url = URL(string: "\(Constants.WS_VideoUrl)/\(sender?.accessibilityHint ?? "")")
        {
            player = AVPlayer(url: url)
        }
        let controller = AVPlayerViewController()
        let videoLayer = CALayer()
        videoLayer.frame = controller.view.frame
        present(controller, animated: true)
        controller.player = player
        player?.play()
    }
    
    @objc  func sharebuttonAction(_ sender: UIButton?)
    {
    
        let notificationdataone:MyVideosModelClass = self.myVideosdata[(sender?.tag)!]
        
        var textToShare: String? = nil
        if let value = notificationdataone.friend_name
        {
            textToShare = "Hey i got a suprising wish video from \(value). Lets watch it <br> \("\(Constants.WS_VideoUrl)/\(sender?.accessibilityHint ?? "")")"
        }
    
        let image = UIImage(named: "AppIcon")
        var shareAll = [Any]()
            shareAll = [textToShare, image!]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    
    }
    
    
    
   
}


