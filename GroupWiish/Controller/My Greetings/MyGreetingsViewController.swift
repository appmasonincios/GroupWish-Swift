//
//  MyGreetingsViewController.swift
//  GroupWiish
//
//  Created by apple on 05/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import SideMenu
import Kingfisher
import SwiftyJSON
import Alamofire
import ViewAnimator
import PopItUp
import DYBadgeButton
class MyGreetingsViewController: UIViewController {

    
    @IBOutlet weak var profilebutton: DYBadgeButton!
    @IBOutlet weak var usernotification: DYBadgeButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var profileimage: ImageViewDesign!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var searchView1: GradientView!
    @IBOutlet weak var searchtextfield:UITextField!
    var myGreetingsModelClassdata = [MyGreetingsModelClass]()
    var orginalmyGreetingsModelClassdata = [MyGreetingsModelClass]()
    var filterArray = [MyGreetingsModelClass]()
    var searchedArray = [MyGreetingsModelClass]()
    var countdictionary:Counts? = nil
    var booleancheck:Bool = false
    var dueTodayCount:Int = 0
    var pastDueCount:Int = 0
    var leftConstraint: NSLayoutConstraint!
    private let image = UIImage(named: "receivedgreetings-inactive")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = ""
    private let bottomMessage = "No Greetings Found"
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    override func viewDidLoad()
    {
        super.viewDidLoad()
      NotificationCenter.default.addObserver(self, selector: #selector(sendmessagesetup(notification:)), name: NSNotification.Name(rawValue: "showmessage"), object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(showsimplemessagesteup(notification:)), name: NSNotification.Name(rawValue: "showsimplemessage"), object: nil)
        
       setupEmptyBackgroundView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        userlogout()
        profileimagedisplay()
        ui()
        savesharedprefrence(key:Constants.TABTYPE, value:"1")
        savesharedprefrence(key:Constants.toasttype, value:"")
        self.getdata()
        self.searchtextfield.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("VideoSentNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoSentMessage(_:)), name: NSNotification.Name("VideoSentNotification"), object: nil)
        
        self.bedgecountapi()
    }
    
    @objc func showsimplemessagesteup(notification:Notification)
    {
        self.showToast(message:"Uploaded Successfully")
    }
  @objc func sendmessagesetup(notification:Notification)
    {
        self.showToast(message:"Card Send Successfully")
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
                let str = strCountry.recipient_name
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
   
    func bedgecountapi()
    {
        self.getrequestcount()
        
        let usercount:String = getSharedPrefrance(key:Constants.USERCOUNT)
        
        if usercount == "" || usercount == "0"
        {
            self.profilebutton!.badgeString = "0"
        }
        else
        {
            self.profilebutton!.badgeString = usercount
        }
        let unseencount:String = getSharedPrefrance(key:Constants.UNSEENCOUNT)
        if unseencount == "" || unseencount == "0"
        {
            self.usernotification!.badgeString = "0"
        }
        else
        {
            self.usernotification!.badgeString = unseencount
        }
    }
    
    @objc func videoSentMessage(_ notification: Notification?)
    {
        if ((notification?.name)!.rawValue == "VideoSentNotification")
        {
            Shared.sharedInstance().customAlert(withMessage: "Video sent successfully..", titleMessage: "Success", on: self, typeOfAlert: "1")
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("VideoSentNotification"), object: nil)
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
    
    func userlogout()
    {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name("ULO1"), object: nil)
        nc.addObserver(self, selector: #selector(userLoggedIn1), name: Notification.Name("UserLoggedOut1"), object: nil)
        nc.addObserver(self, selector: #selector(FILTERDUETODAYMyGREETINGMODELCLASS), name: Notification.Name(Constants.FILTERDUETODAY + Constants.MyGREETINGMODELCLASS), object: nil)
        nc.addObserver(self, selector: #selector(FILTERPASTDUEMyGREETINGMODELCLASS), name: Notification.Name(Constants.PASTDUE + Constants.MyGREETINGMODELCLASS), object: nil)
    }
    
    
    func ui()
    {
        gradientView.colors = topbarcolor()
        searchView1.colors = topbarcolor()
        setupSideMenu()
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    
    @IBAction func searchbuttonaction(_ sender: Any)
    {
        booleancheck = true
        self.searchView1.isHidden = false
    }
    @IBAction func cancelbuttonaction(_ sender: Any)
    {
        booleancheck = false
        self.searchView1.isHidden = true
        self.tableview.reloadData()
    }
    

    @objc func userLoggedIn()
    {
        dismiss(animated:true, completion:{
            self.presentPopup(TestPopupViewController(),
                         animated: true,
                         backgroundStyle: .blur(.dark), // present the popup with a blur effect has background
                constraints: [.leading(16), .trailing(16),.height(217)], // fix leading edge and the width
                transitioning: .slide(.left), // the popup come and goes from the left side of the screen
                autoDismiss: false, // when touching outside the popup bound it is not dismissed
                completion: nil)
        })
        
    }
    
    @objc func FILTERDUETODAYMyGREETINGMODELCLASS()
    {
       self.filterArray.removeAll()
        
        self.myGreetingsModelClassdata.removeAll()
        
        for item in self.orginalmyGreetingsModelClassdata
        {
            if item.dueby == "Due Today"
            {
                self.filterArray.append(item)
            }
            
        }
        self.myGreetingsModelClassdata.append(contentsOf:self.filterArray)
        self.tableview.reloadData()
    }
    
    @objc func FILTERPASTDUEMyGREETINGMODELCLASS()
    {
          self.filterArray.removeAll()
        
        for item in self.orginalmyGreetingsModelClassdata
        {
            if item.dueby == "Past Due"
            {
                self.filterArray.append(item)
            }
            self.myGreetingsModelClassdata.removeAll()
            self.myGreetingsModelClassdata.append(contentsOf:self.filterArray)
            self.tableview.reloadData()
        }
    }
    

    @objc func userLoggedIn1()
    {
        savesharedprefrence(key:"loginsession", value:"false")
            logout()
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        UIApplication.shared.delegate?.window!?.rootViewController = loginVC
        UIApplication.shared.delegate?.window!!.makeKeyAndVisible()
    
        
    }
    
      func setupSideMenu()
      {
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = CGFloat(0)
        SideMenuManager.default.menuWidth = self.view.frame.width/2+120
    }
    
   
    @IBAction func filterbuttonaction(_ sender: Any)
    {
        let filterPopupViewController:FilterPopupViewController = FilterPopupViewController()
        filterPopupViewController.pastDuecount = self.countdictionary?.pastDue ?? 0
        filterPopupViewController.duetodaycount = self.countdictionary?.dueToday ?? 0
        presentPopup(filterPopupViewController,
                     animated: true,
                     backgroundStyle: .blur(.dark), // present the popup with a blur effect has background
            constraints: [.leading(16), .trailing(16),.height(206)], // fix leading edge and the width
            transitioning: .slide(.right), // the popup come and goes from the left side of the screen
            autoDismiss: false, // when touching outside the popup bound it is not dismissed
            completion: nil)
    }
    
    
    
    func getdata()
    {
        executeGETHEADER(view: self.view, path: Constants.LIVEURL + Constants.greeting_list + "?userid=" + getSharedPrefrance(key:Constants.ID)){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                self.myGreetingsModelClassdata.removeAll()
                for store in response["data"].arrayValue
                {
                  self.myGreetingsModelClassdata.append(MyGreetingsModelClass(json:store.dictionaryObject!)!)
                  self.orginalmyGreetingsModelClassdata.append(MyGreetingsModelClass(json:store.dictionaryObject!)!)
                }
            
                self.countdictionary = Counts(json:response["counts"].dictionaryObject!)
                
               self.tableview.reloadData()
                UIView.animate(views: self.tableview.visibleCells, animations: self.animations, completion: {
                })
            }
            else
            {
              //  self.showToast(message:response["errors"].string ?? "")
            }
        }
    }

    @objc func toggle() {
        
        let isOpen = leftConstraint.isActive == true
        
        // Inactivating the left constraint closes the expandable header.
        leftConstraint.isActive = isOpen ? false : true
        
        // Animate change to visible.
        UIView.animate(withDuration: 1, animations: {
            self.navigationItem.titleView?.alpha = isOpen ? 0 : 1
            self.navigationItem.titleView?.layoutIfNeeded()
        })
    }
    
    @IBAction func profilebuttonaclicked(_ sender: Any)
    {
        profileclicked()
    }
    
    @IBAction func friendsBtnTapped(_ sender: Any)
    {
       requestViewController()
    }
    
  @objc  func receivedVideoAction(_ sender: UIButton?)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReceivedVideosViewControllern") as? ReceivedVideosViewControllern
        vc?.greeting_id =  self.myGreetingsModelClassdata[sender?.tag ?? 0].id ?? ""
        vc?.myGreetingsModel = self.myGreetingsModelClassdata[sender?.tag ?? 0]
        if let vc = vc {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MyGreetingsViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if booleancheck == false
        {
            if myGreetingsModelClassdata.count == 0 {
                tableView.separatorStyle = .none
                tableView.backgroundView?.isHidden = false
            } else {
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
        
        let cell:MyGrettingTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyGrettingTableViewCell", for:indexPath) as! MyGrettingTableViewCell
        
        var myGreetingsModel:MyGreetingsModelClass? = nil
        
        if  booleancheck == false
        {
             myGreetingsModel = self.myGreetingsModelClassdata[indexPath.row]
        }
        else
        {
             myGreetingsModel = self.searchedArray[indexPath.row]
        }
    
        if let constantName = myGreetingsModel?.recipient_image
        {
            let imageURL = URL(string:Constants.WS_ImageUrl + "/" + constantName)!
            cell.grettingprofileimage.kf.setImage(with:imageURL,
                                          placeholder: UIImage(named:"no-user-img.png"),
                                          options: [.transition(ImageTransition.fade(1))],
                                          progressBlock: { receivedSize, totalSize in },
                                          completionHandler: { image, error, cacheType, imageURL in})
            
        } else
        {
         //no-user-img
            
            cell.grettingprofileimage.image = UIImage.init(named:"no-user-img.png")
            // the value of someOptional is not set (or nil).
        }
    
        if let constantName = myGreetingsModel?.image
        {
            let url = URL(string:Constants.WS_ImageUrl + "/" + constantName)
            cell.mainimage.kf.setImage(with: url,
                                         placeholder: UIImage(named:"image_sample.png"),
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in },
                                         completionHandler: { image, error, cacheType, imageURL in})
        } else {
            // the value of someOptional is not set (or nil).
        }


        cell.profilename.text  = myGreetingsModel?.recipient_name
        cell.title.text = myGreetingsModel?.title
        cell.timelabel.text = myGreetingsModel?.dueby
        
        if myGreetingsModel?.videos_cnt != "" && myGreetingsModel?.videos_cnt != nil
        {
            cell.countlabel.text = myGreetingsModel?.videos_cnt
        }
        else
        {
              cell.countlabel.text = "0"
        }
      
        cell.numberOfVideosBtn.tag = indexPath.row
        cell.numberOfVideosBtn.addTarget(self, action:#selector(receivedVideoAction(_:)), for:.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 380.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         let myGreetingsModel:MyGreetingsModelClass = self.myGreetingsModelClassdata[indexPath.row]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GreetingDetailViewController1") as! GreetingDetailViewController1
        vc.id = myGreetingsModel.id ?? ""
        if myGreetingsModel.videos_cnt != "" && myGreetingsModel.videos_cnt != nil
        {
            vc.greeting_id = myGreetingsModel.videos_cnt ?? ""
        }
        else
        {
            vc.greeting_id = "0"
        }
        
    self.navigationController?.pushViewController(vc, animated: true)

    }
    
}

