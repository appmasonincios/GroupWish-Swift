//
//  NotificationViewController.swift
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
import MobileCoreServices
import DYBadgeButton
class NotificationViewController: UIViewController
{
    @IBOutlet weak var usernotification: DYBadgeButton!
    @IBOutlet weak var profilebutton: DYBadgeButton!
    @IBOutlet weak var searchView: GradientView!
    @IBOutlet var searchtextfield: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var profileimage: ImageViewDesign!
    private let image = UIImage(named: "black-email")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = ""
    private let bottomMessage = "No Notifications Found"
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    var imagePicker = UIImagePickerController()
    var greeting_id:String? = nil
    var friend_id:String? = nil
    var notificationdata = [NotificationClass]()
    var orginalnotificationdata = [NotificationClass]()
    var filterArray = [NotificationClass]()
    var booleancheck:Bool = false
    var searchedArray = [NotificationClass]()
    var mainimageheight:CGFloat = 220.0
    var titlestr:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(openCamera), name: Notification.Name(Constants.openCamera), object: nil)
        nc.addObserver(self, selector: #selector(openGallary), name: Notification.Name(Constants.openGallary), object: nil)
         nc.addObserver(self, selector: #selector(backview), name: Notification.Name("backview"), object: nil)
        self.searchtextfield.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        gradientView.colors = topbarcolor()
        searchView.colors = topbarcolor()
        setupSideMenu()
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
         userlogout()
        setupEmptyBackgroundView()
          KanvasSDK.initialize(withClientID:Constants.KanvasSDKClientID, signature:Constants.KanvasSDKsignature)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        savesharedprefrence(key:Constants.TABTYPE, value:"5")
       profileimagedisplay()
        self.setupApis()
        self.bedgecountapi()
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
    
    
    @objc func openCamera()
    {
        let videoPicker = UIImagePickerController()
        videoPicker.sourceType = .camera
        if let available = UIImagePickerController.availableMediaTypes(for: .camera) {
            videoPicker.mediaTypes = available
        }
        videoPicker.delegate = self
        videoPicker.cameraCaptureMode = .video
        videoPicker.allowsEditing = true
        videoPicker.mediaTypes = [kUTTypeMovie as String]
        videoPicker.videoMaximumDuration = 15
        dismiss(animated: true)
        present(videoPicker, animated: true)
        
    }
    
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
        videoPicker.videoMaximumDuration = 15
        videoPicker.videoQuality = .typeHigh
        videoPicker.allowsEditing = true
        dismiss(animated: true)
        present(videoPicker, animated: true)
     
    }
    
    @objc func backview()
    {
      self.showToast(message:"Uploaded Successfully")
         self.bedgecountapi()
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
            for strCountry in self.notificationdata
            {
                let str = strCountry.username
                let range = str?.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                
                if range != nil
                {
                    searchedArray.append(strCountry)
                }
            }
        } else
        {
            searchedArray = self.notificationdata
        }
        
        tableview.reloadData()
    }
    
    
    func userlogout()
    {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name("ULO5"), object: nil)
        nc.addObserver(self, selector: #selector(userLoggedIn1), name: Notification.Name("UserLoggedOut5"), object: nil)
        
        nc.addObserver(self, selector: #selector(FILTERDUETODAYMyGREETINGMODELCLASS), name: Notification.Name(Constants.FILTERDUETODAY + Constants.NOTIFICATIONCLASS), object: nil)
        nc.addObserver(self, selector: #selector(FILTERPASTDUEMyGREETINGMODELCLASS), name: Notification.Name(Constants.PASTDUE + Constants.NOTIFICATIONCLASS), object: nil)
    }
    
    
    @objc func FILTERDUETODAYMyGREETINGMODELCLASS()
    {
        self.notificationdata.removeAll()
        self.filterArray.removeAll()
        
        for item in self.orginalnotificationdata
        {
            if item.dueby == "Due by Today"
            {
                self.filterArray.append(item)
            }
        }
    
        self.notificationdata.append(contentsOf:self.filterArray)
        self.tableview.reloadData()
    }
    
    @objc func FILTERPASTDUEMyGREETINGMODELCLASS()
    {
        self.filterArray.removeAll()
        self.notificationdata.removeAll()
       
        for item in self.orginalnotificationdata
        {
            if item.dueby == "Past Due"
            {
                self.filterArray.append(item)
            }
            self.notificationdata.append(contentsOf:self.filterArray)
            self.tableview.reloadData()
        }
    }
    
    @IBAction func profilebuttonaclicked(_ sender: Any)
    {
        self.profileclicked()
    }
    
    @IBAction func notificationbuttonaction(_ sender: Any)
    {
        self.requestViewController()
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
    
    @IBAction func filterbuttonaction(_ sender: Any)
    {
        presentPopup(FilterPopupViewController(),
                     animated: true,
                     backgroundStyle: .blur(.dark), // present the popup with a blur effect has background
            constraints: [.leading(16), .trailing(16),.height(206)], // fix leading edge and the width
            transitioning: .slide(.right), // the popup come and goes from the left side of the screen
            autoDismiss: false, // when touching outside the popup bound it is not dismissed
            completion: nil)
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
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = CGFloat(0)
        
    }
    
    func setupApis()
    {
        let url = Constants.LIVEURL + Constants.friends_greetings_list + "?userid=" + getSharedPrefrance(key:Constants.ID)
        executeGET(view: self.view, path:url){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                self.notificationdata.removeAll()
                self.orginalnotificationdata.removeAll()
                
                    for store in response["data"].arrayValue
                    {
             self.notificationdata.append(NotificationClass(json:store.dictionaryObject!)!)
             self.orginalnotificationdata.append(NotificationClass(json:store.dictionaryObject!)!)
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
    
    
}


extension NotificationViewController:UITableViewDelegate,UITableViewDataSource
 {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if booleancheck == false
        {
            if notificationdata.count == 0
            {
                tableView.separatorStyle = .none
                tableView.backgroundView?.isHidden = false
            } else {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView?.isHidden = true
            }
            return notificationdata.count
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier:"NotificationTableViewCell", for:indexPath) as! NotificationTableViewCell
    
        var notificationdataone:NotificationClass? = nil
        
        if  booleancheck == false
        {
            notificationdataone = self.notificationdata[indexPath.row]
        }
        else
        {
            notificationdataone = self.searchedArray[indexPath.row]
        }
        
        if let constantName = notificationdataone?.profile_pic
        {
            let imageURL = URL(string:Constants.WS_ImageUrl + "/" + constantName)
            cell.profileimage.kf.indicatorType = .activity
            cell.profileimage.kf.setImage(with:imageURL)
        }
        else
        {
            // the value of someOptional is not set (or nil).
        }
        
        if let constantName = notificationdataone?.image
        {
            let imageURL = URL(string:Constants.WS_ImageUrl + "/" + constantName)
            cell.mainimage.kf.indicatorType = .activity
            cell.mainimage.kf.setImage(with:imageURL)
        } else {
            // the value of someOptional is not set (or nil).
        }

        cell.titlelabel.text = notificationdataone?.title
        cell.username.text = notificationdataone?.username
        cell.subtitle.text = convertDateFormater(notificationdataone?.created_date ?? "")
        cell.simpletextview.text = notificationdataone?.message
        cell.timelabel.text  = notificationdataone?.dueby
    
        if notificationdataone?.video_sent == 0 && notificationdataone?.dueby != "Past Due"
        {
          cell.sendreplayview.isHidden = false
        }
        else
        {
            cell.sendreplayview.isHidden = true
        }
        cell.sendreplaybutton.tag = indexPath.row
        cell.sendreplaybutton.addTarget(self, action:#selector(sendreplaybutton(sender:)), for:.touchUpInside)
        return cell
    }
    
    
    @objc  func sendreplaybutton(sender:UIButton)
    {
        if booleancheck == false
        {
            self.greeting_id = self.notificationdata[sender.tag].id
            self.friend_id = self.notificationdata[sender.tag].recipient_id
             self.titlestr = self.notificationdata[sender.tag].title
        }
        else
        {
            self.greeting_id = self.searchedArray[sender.tag].id
            self.friend_id = self.searchedArray[sender.tag].recipient_id
            self.titlestr = self.searchedArray[sender.tag].title
        }
       
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "AddSelectVideoVC") as? AddSelectVideoVC else { return }
        popupVC.popupDelegate = self
        present(popupVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 357.0
    }
    
    
}

extension NotificationViewController: BottomPopupDelegate {
    
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

extension NotificationViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate,KVNCameraViewControllerDelegate,KVNEditViewControllerDelegate
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
    
    func cameraViewController(_ cameraViewController: KVNCameraViewController!, didFinishWithVideo fileURL: URL!) {
        // Do Nothing
    }
    
    func cameraViewController(_ cameraViewController: KVNCameraViewController!, didFinishWithGifURL fileURL: URL!) {
        // Do Nothing
    }
    
    func cameraViewController(_ cameraViewController: KVNCameraViewController!, willDismiss sender: Any!) {
        // [cameraViewController dismissViewControllerAnimated:YES completion:nil];
        cameraViewController.dismiss(animated:true, completion:nil)
    }
    
    func editViewController(_ viewController: KVNEditViewController!, backButtonPressed sender: Any!) {
        // [viewController dismissViewControllerAnimated:YES completion:nil];
        
        viewController.dismiss(animated:true, completion:nil)
    }
    
    func editViewController(_ viewController: KVNEditViewController!, createdImage image: KVNOutputImage!) {
        // Do Nothing
    }
    
    func editViewController(_ viewController: KVNEditViewController!, createdVideo videoDataURL: URL!)
    {
        dismiss(animated: true)
        {
            if videoDataURL != nil
            {
                let previewVideoViewController:PreviewVideoViewController = self.storyboard?.instantiateViewController(withIdentifier:"PreviewVideoViewController") as! PreviewVideoViewController
                previewVideoViewController.friend_id = self.friend_id
                previewVideoViewController.greeting_id = self.greeting_id
                previewVideoViewController.videoDataURL = videoDataURL
                previewVideoViewController.titlestr = self.titlestr
                self.navigationController?.pushViewController(previewVideoViewController, animated:false)
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
            if durationInSeconds <= 16
            {
                picker.dismiss(animated:true, completion:{
                    self.presentEdit(videoURL)
                })
                
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

class ScaledHeightImageView: ImageViewDesign {
    
    override var intrinsicContentSize: CGSize
    {
        if let myImage = self.image
        {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
    
}
