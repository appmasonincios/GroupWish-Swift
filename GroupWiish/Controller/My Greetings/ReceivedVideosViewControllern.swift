//
//  ReceivedVideosViewController.swift
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
import AVFoundation
import AVKit
import PopItUp
import MobileCoreServices
import CoreFoundation
class ReceivedVideosViewControllern: UIViewController {
 
    @IBOutlet weak var gradientview: GradientView!
    @IBOutlet weak var selectimage: UIImageView!
    @IBOutlet weak var searchView: GradientView!
    @IBOutlet var searchtextfield: UITextField!
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var arrangeBtn: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var videosLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
     private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
      var booleancheck:Bool = false
    var cell: ReceivedVideosTableViewCelln?
    var greeting_id = ""
    var myGreetingsModel:MyGreetingsModelClass? = nil
    var Filter = false
    var SelectAll = false
    var greeting_VideosModelClass = [Greeting_VideosModelClass]()
     var searchedArray = [Greeting_VideosModelClass]()
    var checkedArray = [Greeting_VideosModelClass]()
    override func viewDidLoad() {
        super.viewDidLoad()

         self.selectimage.isHighlighted = true
        self.videosTableView.delegate = self
        self.videosTableView.dataSource = self
       
        //  self.searchtextfield.delegate = self
        self.searchtextfield.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.gallery),
            name:NSNotification.Name(rawValue: "gallery"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.record),
            name:NSNotification.Name(rawValue: "record"),
            object: nil)
    
        Filter                 = false
        SelectAll              = true
        gradientview.colors = topbarcolor()
       
        self.searchView.colors = topbarcolor()
            KanvasSDK.initialize(withClientID: "59acccd92257524f1e7b4bdf", signature: "MEUCIQD4VY+Wtnok/r+iV62815L2vcpE9Js9wSjxSObCYkCZ0AIgLNeu6FOQjtVwmfuyhkFoKwZWrpCYX0zuRnx91m+KZaw=")
        videosTableView.backgroundColor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1)
        self.videosTableView.estimatedRowHeight = 320;
        self.videosTableView.rowHeight          = UITableView.automaticDimension;
    
        getData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
         savesharedprefrence(key:Constants.toasttype, value:"0")
    }
    
    @objc func searchRecordsAsPerText(_ textfield:UITextField)
    {
        searchedArray.removeAll()
        if textfield.text?.characters.count != 0
        {
            for strCountry in self.greeting_VideosModelClass
            {
                let str = strCountry.friend_name
                let range = str?.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                if range != nil
                {
                    searchedArray.append(strCountry)
                }
            }
        } else {
            searchedArray = self.greeting_VideosModelClass
        }
        
        videosTableView.reloadData()
    }
    @objc func choosePopupViewController()
    {
        dismiss(animated:true, completion:nil)
        presentPopup(ChoosePopupViewController(),
                     animated: true,
                     backgroundStyle: .blur(.dark), // present the popup with a blur effect has background
            constraints: [.leading(16), .trailing(16),.height(250)], // fix leading edge and the width
            transitioning: .slide(.left), // the popup come and goes from the left side of the screen
            autoDismiss: false, // when touching outside the popup bound it is not dismissed
            completion: nil)
    }
    
    
    @objc func gallery()
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
        
        dismiss(animated: true)
        present(videoPicker, animated: true)
    }
    @objc func record()
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
    
    @IBAction func searchbuttonaction(_ sender: Any)
    {
        booleancheck = true
        self.searchView.isHidden = false
    }
    @IBAction func cancelbuttonaction(_ sender: Any)
    {
        booleancheck = false
        self.searchView.isHidden = true
        self.videosTableView.reloadData()
    }
    
    
    func getData()
    {
        
        var parameters = [String:Any]()
        parameters["id"] = getSharedPrefrance(key:Constants.ID)
        parameters["greeting_id"] = self.greeting_id
        var urlString = ""
        if let object = parameters["id"], let object1 = parameters["greeting_id"] {
            urlString = "\(Constants.LIVEURL)/\(Constants.greeting_videos)?userid=\(object)&greeting_id=\(object1)"
        }
        
        executeGET(view: self.view, path:urlString){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                self.greeting_VideosModelClass.removeAll()

                for store in response["data"].arrayValue
                {
                    self.greeting_VideosModelClass.append(Greeting_VideosModelClass(json:store.dictionaryObject!)!)
                }

                self.videosTableView.reloadData()
                UIView.animate(views: self.videosTableView.visibleCells, animations: self.animations, completion: {

                })
                
            }
            else
            {
                //self.showToast(message:response["errors"].string ?? "")
            }
        }
        
        
        func uploadvideo(parameter:[String:Any],video_url:URL?)
        {//UIImage.jpegData(image)(compressionQuality:0.4)
            let url = Constants.LIVEURL + Constants.send_video_host
            self.showLoader(view: self.view)
            
    
            let headers = [
                "Authorization": getSharedPrefrance(key:Constants.TOKEN)]

            
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
                                            
                                           self.getData()
                                            
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
                                self.showToast(message:"OOPS! Some thing wrong,Please try again..")
                                self.hideLoader(view: self.view)
                            }
                        }
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                }
            }
        }
        
        
        
    }
    
    
    @objc func checkbuttonaction(sender:UIButton)
    {
        let boolean = self.checkedArray.contains(where: { element in element.id == self.greeting_VideosModelClass[sender.tag].id
        })
        if boolean == true
        {
            self.checkedArray.removeAll (where: { element in element.id == self.greeting_VideosModelClass[sender.tag].id
            })
            self.videosTableView.reloadData()
        }
        else
        {
            self.checkedArray.append(self.greeting_VideosModelClass[sender.tag])
        }

        self.videosTableView.reloadData()
    }

    
    func upload(parameter:[String:Any],video_url:URL?)
    {//UIImage.jpegData(image)(compressionQuality:0.4)
        
        let headers = [
            "Authorization": getSharedPrefrance(key:Constants.TOKEN)]
        let url = Constants.LIVEURL + Constants.send_video_host
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
                                        
                                        self.getData()
                                    }
                                    else
                                    {
                                        self.showToast(message:jsonResult["errors"] as? String ?? "")
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
   

    @objc func playBtnAction(_ sender: UIButton?) {
        var player: AVPlayer? = nil
        if let accessibilityHint = sender?.accessibilityHint, let url = URL(string: "\(Constants.WS_VideoUrl)/\(accessibilityHint)") {
            player = AVPlayer(url: url)
        }
        
        let controller = AVPlayerViewController()
        present(controller, animated: true)
        controller.player = player
        player?.play()
    }
   
    
   
    
    @IBAction func videoAction(_ sender: Any)
    {
        choosePopupViewController()
    }
    
    @IBAction func backAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated:false)
    }
    
    @IBAction func arrangeAction(_ sender: Any)
    {
        if self.greeting_VideosModelClass.count > 0
        {
            if checkedArray.count >= 2
            {
                let vc = storyboard?.instantiateViewController(withIdentifier: "ArrangeVideosViewController") as? ArrangeVideosViewController
                vc?.videosArray = self.greeting_VideosModelClass
                vc?.selectedArray = self.checkedArray
                vc?.greeting_id = self.greeting_id
                vc?.myGreetingsModel = self.myGreetingsModel
                if let vc = vc {
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
            else
            {
                self.showToast(message:"Atleast two videos required to merge")
            }
    
        }
        else
        {
            let actionsheet = UIAlertController(title: "Choose From", message: "Please select an option", preferredStyle: .actionSheet)
            let gallery = UIAlertAction(title: "Choose from Gallery", style: .default, handler: { action in
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
            })
            let camera = UIAlertAction(title: "Record Video", style: .default, handler: { action in
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
                
                self.present(videoPicker, animated: true)
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            })
            
            actionsheet.addAction(gallery)
            actionsheet.addAction(camera)
            actionsheet.addAction(cancel)
            
            
        }
    
    }
    
    @IBAction override func selectAll(_ sender: Any?)
    {
        if SelectAll
        {
          self.checkedArray.removeAll()
          self.checkedArray.append(contentsOf:self.greeting_VideosModelClass)
            
            if let font = UIFont(name: "FontAwesome5FreeSolid", size: 15.0)
            {
                selectAllBtn.titleLabel?.font = font
            }
             SelectAll = false
            selectAllBtn.setTitle("Unselect All", for: .normal)
            selectAllBtn.isSelected = false
            self.selectimage.isHighlighted = false
        }
        else
        {
            self.checkedArray.removeAll()
            if let font = UIFont(name: "FontAwesome5FreeSolid", size: 15.0) {
                selectAllBtn.titleLabel?.font = font
            }
            self.selectAllBtn.setTitle("Select All", for: .normal)
            self.selectAllBtn.isSelected = true
            self.selectimage.isHighlighted = true
            
            SelectAll = true
            
        }
        self.videosTableView.reloadData()
    }

}

extension ReceivedVideosViewControllern:UITableViewDelegate,UITableViewDataSource
{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if booleancheck == false
        {
            return self.greeting_VideosModelClass.count
        }
        else
        {
            return searchedArray.count
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:ReceivedVideosTableViewCelln = tableView.dequeueReusableCell(withIdentifier:"ReceivedVideosTableViewCelln") as! ReceivedVideosTableViewCelln
        
         var greeting_VideosModelClass:Greeting_VideosModelClass? = nil
        
        if  booleancheck == false
        {
            greeting_VideosModelClass = self.greeting_VideosModelClass[indexPath.row]
        }
        else
        {
            greeting_VideosModelClass = self.searchedArray[indexPath.row]
        }
    
        cell.userName.text            = greeting_VideosModelClass?.friend_name
        cell.titleLbl.text            =  greeting_VideosModelClass?.title
        
        cell.datetime.text            = greeting_VideosModelClass?.datetime
        
        cell.checkBtn.tag = indexPath.row;
        
        
        cell.checkBtn.addTarget(self, action:#selector(method), for:.touchUpInside)
        
        
        cell.playBtn.tag = indexPath.row;
        
        cell.playBtn.accessibilityHint = self.greeting_VideosModelClass[indexPath.row].video_name
        
        cell.playBtn.addTarget(self, action:#selector(playBtnAction), for:.touchUpInside)
        
        
        if let constantName = greeting_VideosModelClass?.thumb_image
        {
            let imageURL = URL(string:Constants.WS_ImageUrl + "/" + constantName)!
            
            cell.mainImage.kf.indicatorType = .activity
            cell.mainImage.kf.setImage(with:imageURL)
            //statements using 'constantName'
        } else {
            
            cell.mainImage.image = UIImage.init(named:"placeHolder")
        }
        
        if let constantName = greeting_VideosModelClass?.profile_pic
        {
            let imageURL = URL(string:Constants.WS_ImageUrl + "/" + constantName)!
            
            cell.userImage.kf.indicatorType = .activity
            cell.userImage.kf.setImage(with:imageURL)
            //statements using 'constantName'
        } else {
            // the value of someOptional is not set (or nil).
        }
        //list["datetime"]
        
        cell.datetime.text = Shared.sharedInstance().relativeDateString(for: Shared.sharedInstance().dateconvert(self.greeting_VideosModelClass[indexPath.row].datetime, format: "yyyy-MM-dd HH:mm:ss", convertion: true) as? Date)
        
         cell.checkBtn.tag = indexPath.row

        cell.checkBtn.addTarget(self, action: #selector(checkbuttonaction), for: .touchUpInside)
        cell.playBtn.tag = indexPath.row
        cell.playBtn.accessibilityHint = greeting_VideosModelClass?.video_name
        cell.playBtn.addTarget(self, action: #selector(self.playBtnAction(_:)), for: .touchUpInside)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        cell.layer.backgroundColor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1).cgColor
        
        
        let boolean = self.checkedArray.contains(where: { element in element.id == greeting_VideosModelClass?.id
        })
        if boolean == true
        {
            cell.checkImage.isHighlighted = true
        }
        else
        {
            cell.checkImage.isHighlighted = false
        }
        
         self.videoBtn.isHidden = false
        
         if (self.greeting_VideosModelClass[indexPath.row].user_id == "\(getSharedPrefrance(key:Constants.ID))")
          {
                //videoBtn.isEnabled = false
                videoBtn.isHidden = true
                videoBtn.alpha = 0.5
            }
       

    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 320.0
    }
    
  
}


extension ReceivedVideosViewControllern:UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
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

extension ReceivedVideosViewControllern:KVNCameraViewControllerDelegate,KVNEditViewControllerDelegate
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
        
        cameraViewController.dismiss(animated:true, completion:nil)
    }
    
    func editViewController(_ viewController: KVNEditViewController!, backButtonPressed sender: Any!) {
        
        viewController.dismiss(animated:true, completion:nil)
    }
    
    func editViewController(_ viewController: KVNEditViewController!, createdImage image: KVNOutputImage!) {
         // Do Nothing
    }
    
  
    
    func editViewController(_ viewController: KVNEditViewController!, createdGif gifDataURL: URL!)
    {
        
        // Do Nothing
    }
    
    
    func editViewController(_ viewController: KVNEditViewController!, createdVideo videoDataURL: URL!)
    {
        dismiss(animated: true)
        {
            var parameters = [String:Any]()
            parameters["userid"] = getSharedPrefrance(key:Constants.ID)
            parameters["type"] = "self"
            parameters["greeting_id"] = self.greeting_id
            self.upload(parameter:parameters, video_url:videoDataURL)
        }
    
    
    
    
    }
}
