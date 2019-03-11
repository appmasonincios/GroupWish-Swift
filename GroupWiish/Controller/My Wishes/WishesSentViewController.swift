//
//  WishesSentViewController.swift
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
import PopItUp
import AVFoundation
import AVKit
import DYBadgeButton
class WishesSentViewController: UIViewController {
   
    @IBOutlet weak var profilebutton: DYBadgeButton!
    @IBOutlet weak var usernotification: DYBadgeButton!
    @IBOutlet weak var searchView: GradientView!
    @IBOutlet var searchtextfield: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var profileimage: ImageViewDesign!
    @IBOutlet weak var gradientView: GradientView!
    private let image = UIImage(named: "home-empty")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = ""
    private let bottomMessage = "No Videos Found"
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    var booleancheck:Bool = false
    var myGreetingsModelClassdata = [MyVideosHistoryModelClass]()
    var searchedArray = [MyVideosHistoryModelClass]()
    var leftConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savesharedprefrence(key:Constants.menunumber, value:"3")
       
        self.searchtextfield.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
         profileimagedisplay()
        gradientView.colors = topbarcolor()
        searchView.colors = topbarcolor()
        setupSideMenu()
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        setupEmptyBackgroundView()
        
        
        bedgecountapi()
        // Do any additional setup after loading the view.
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
    
    func profileimagedisplay() {
        
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

    func setupEmptyBackgroundView()
    {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.tableview.backgroundView = emptyBackgroundView
    }
    
    @objc func searchRecordsAsPerText(_ textfield:UITextField)
    {
        searchedArray.removeAll()
        if textfield.text?.characters.count != 0
        {
            for strCountry in self.myGreetingsModelClassdata
            {
                let str = strCountry.friend_name
                let range = str?.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                if range != nil
                {
                    searchedArray.append(strCountry)
                }
            }
        } else {
            searchedArray = self.myGreetingsModelClassdata
        }
        
        tableview.reloadData()
    }
    
    func setupSideMenu()
    {
        // Define the menus
        // greeting_list
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = CGFloat(0)
        SideMenuManager.default.menuWidth = self.view.frame.width/2+120
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        getdata()
        
    }
    func getdata()
    {
        executeGET(view: self.view, path: Constants.LIVEURL + Constants.videos_history + "?userid=" + getSharedPrefrance(key:Constants.ID))
        { response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                self.myGreetingsModelClassdata.removeAll()
                for store in response["data"].arrayValue
                {
            self.myGreetingsModelClassdata.append(MyVideosHistoryModelClass(json:store.dictionaryObject!)!)
                }
                self.tableview.reloadData()
                UIView.animate(views: self.tableview.visibleCells, animations: self.animations, completion: {
                })
            }
            else
            {
               // self.showToast(message:response["errors"].string ?? "")
            }
        }
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
    
    @objc  func sharebuttonAction(_ sender: UIButton?)
    {
        
      
        
    }
    
    @IBAction func profilebuttonaclicked(_ sender: Any)
    {
        profileclicked()
    }
    
   
    @IBAction func friendsBtnTapped(_ sender: Any)
    {
        requestViewController()
    }
    
    
    
    @objc func toggle() {
        
        let isOpen = leftConstraint.isActive == true
    
        leftConstraint.isActive = isOpen ? false : true
        
        // Animate change to visible.
        UIView.animate(withDuration: 1, animations: {
            self.navigationItem.titleView?.alpha = isOpen ? 0 : 1
            self.navigationItem.titleView?.layoutIfNeeded()
        })
    }
}

extension WishesSentViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if booleancheck == false
        {
            if myGreetingsModelClassdata.count == 0
            {
                tableView.separatorStyle = .none
                tableView.backgroundView?.isHidden = false
            }
            else
            {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView?.isHidden = true
            }
            
           return myGreetingsModelClassdata.count
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
        
        let cell:WishesSentTableViewCelln = tableView.dequeueReusableCell(withIdentifier:"WishesSentTableViewCelln", for:indexPath) as! WishesSentTableViewCelln
        
        
        var myGreetingsModel:MyVideosHistoryModelClass? = nil
        
        if  booleancheck == false
        {
              myGreetingsModel = self.myGreetingsModelClassdata[indexPath.row]
        }
        else
        {
            myGreetingsModel = self.searchedArray[indexPath.row]
        }
        
    
        if let constantName = myGreetingsModel?.friend_pic
        {
            let imageURL = URL(string:Constants.WS_ImageUrl + "/" + constantName)!
            cell.profileimage.kf.setImage(with:imageURL,
                                          placeholder: UIImage(named:"no-user-img.png"),
                                          options: [.transition(ImageTransition.fade(1))],
                                          progressBlock: { receivedSize, totalSize in },
                                          completionHandler: { image, error, cacheType, imageURL in})
        }
        else
        {
            // the value of someOptional is not set (or nil).
        }

        if let constantName1 = myGreetingsModel?.thumb_image
        {
            
            let url = URL(string:Constants.WS_ImageUrl + "/" + constantName1)!
            
            cell.thumb_image.kf.setImage(with: url,
                                         placeholder: UIImage(named:"image_sample.png"),
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in },
                                         completionHandler: { image, error, cacheType, imageURL in})
        }
        else
        {
            // the value of someOptional is not set (or nil).
        }
        
        cell.message.text = myGreetingsModel?.message
        
        cell.friend_name.text  = myGreetingsModel?.friend_name
        cell.title.text = myGreetingsModel?.title
        
        if let s = myGreetingsModel?.datetime
        {
            let formatter = DateFormatter()
            let myString = s
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let yourDate: Date? = formatter.date(from: myString)
            formatter.dateFormat = "dd-MMM-yyyy"
            let myStringafd = formatter.string(from: yourDate!)
            cell.datelabel.text = myStringafd
        }
        cell.playbutton1.accessibilityHint = myGreetingsModel?.video_name
       cell.playbutton1.tag = indexPath.row
        cell.playbutton1.addTarget(self, action:#selector(sayAction(_:)), for:.touchUpInside)
        cell.downloadbutton.accessibilityHint = myGreetingsModel?.video_name
       cell.downloadbutton.tag = indexPath.row
        cell.downloadbutton.addTarget(self, action:#selector(downloadbuttonaction(_:)), for:.touchUpInside)
        cell.viewimage.tag = indexPath.row
        cell.viewimage.addTarget(self, action: #selector(viewimagedisplay(_:)), for:.touchUpInside)
         cell.sharebutton.accessibilityHint = myGreetingsModel?.video_name
        cell.sharebutton.tag = indexPath.row
        cell.sharebutton.addTarget(self, action:#selector(sharebuttonaction(_:)), for:.touchUpInside)
        if myGreetingsModel?.thank_card == 1
        {
            cell.viewimageview.isHidden = false
        }
        else
        {
            cell.viewimageview.isHidden = true
        }
    
        return cell
    }
    
    @objc func viewimagedisplay(_ sender: UIButton?)
    {
        var myGreetingsModel:MyVideosHistoryModelClass? = nil
        if  booleancheck == false
        {
            myGreetingsModel = self.myGreetingsModelClassdata[sender?.tag ?? 0]
        }
        else
        {
            myGreetingsModel = self.searchedArray[sender?.tag ?? 0]
        }
         let vc:FullImageViewCardVC = self.storyboard?.instantiateViewController(withIdentifier:"FullImageViewCardVC") as! FullImageViewCardVC
        vc.video_id = myGreetingsModel?.id
        self.navigationController?.pushViewController(vc, animated:false)
    }
    
    
    @objc func sharebuttonaction(_ sender: UIButton?)
    {
        
        var myVideosHistoryModelClass:MyVideosHistoryModelClass? = nil
        
        if  booleancheck == false
        {
            myVideosHistoryModelClass = self.myGreetingsModelClassdata[sender?.tag ?? 0]
        }
        else
        {
            myVideosHistoryModelClass = self.searchedArray[sender?.tag ?? 0]
        }
        var textToShare: String? = nil
        if let value = myVideosHistoryModelClass?.friend_name
        {
            // My sent Wish Video Hey i have sent a Surprising wish video to
            textToShare = "My sent Wish Video Hey i have sent a Surprising wish video to  \(value).\n Lets watch it \n \("\(Constants.WS_VideoUrl)/\(sender?.accessibilityHint ?? "")")  \n Download app now: \n https://play.google.com/store/apps/details?id=com.pyklocal"
        }
        
        let image = UIImage(named: "AppIcon")
        var shareAll = [Any]()
        shareAll = [textToShare, image!]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 360
    }
    
    
}
