//
//  CreateGreetingsViewController.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import SideMenu
import Kingfisher
import DYBadgeButton
import UCZProgressView
class CreateGreetingsViewController: UIViewController {

    @IBOutlet weak var profilebutton: DYBadgeButton!
    @IBOutlet weak var usernotification: DYBadgeButton!
    @IBOutlet weak var selectrecipientTF: UITextField!
    @IBOutlet weak var selectRecipientbutton: UIButton!
    @IBOutlet weak var orginalprofileimage: UIImageView!
    @IBOutlet weak var selectduedate: UIButton!
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var uploadimage: UIImageView!
    @IBOutlet weak var heightoftext: NSLayoutConstraint!
    @IBOutlet weak var countlabel: UILabel!
    @IBOutlet weak var addimage: UIImageView!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var messageTextView:UITextView!
    var textGroup = ["Default"]
    var buttonGroup = [UIButton]()
    var datePicker: UDatePicker? = nil
    var date = Date()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
        messageTextView.text = "Message"
        messageTextView.textColor = UIColor.lightGray
        gradientView.colors = topbarcolor()
        setupSideMenu()
        userNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.bedgecountapi()
        self.profileimagedisplay()
        savesharedprefrence(key:Constants.TABTYPE, value:"3")
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
    func userNotificationCenter()
    {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name("ULO3"), object: nil)
        nc.addObserver(self, selector: #selector(userLoggedIn1), name: Notification.Name("UserLoggedOut3"), object: nil)
       nc.addObserver(
            self,
            selector: #selector(self.showSpinningWheel),
            name:NSNotification.Name(rawValue: "AddPhotoVC"),
            object: nil)
        nc.addObserver(
            self,
            selector: #selector(self.showSpinningWheel),
            name:NSNotification.Name(rawValue: "AddPhotoVC"),
            object: nil)
        nc.addObserver(self, selector: #selector(notification(notification:)), name: Notification.Name(Constants.friendnotification), object: nil)
        
    }
    
    @objc func notification(notification:Notification)
    {
        let username = notification.userInfo?["username"] as? String
        let id = notification.userInfo?["id"] as? String
        self.selectrecipientTF.text = username
        self.selectrecipientTF.tag = Int(id ?? "0") ?? 0
    }
    
    
    @objc func userLoggedIn()
    {
        dismiss(animated:true, completion:nil)
        presentPopup(TestPopupViewController(),
                     animated: true,
                     backgroundStyle: .blur(.dark), // present the popup with a blur effect has background
            constraints: [.leading(16), .trailing(16),.height(217)], // fix leading edge and the width
            transitioning: .slide(.left), // the popup come and goes from the left side of the screen
            autoDismiss: false, // when touching outside the popup bound it is not dismissed
            completion: nil)
    }
    
    
    @objc func userLoggedIn1()
    {
        savesharedprefrence(key:"loginsession", value:"false")
        logout()
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        UIApplication.shared.delegate?.window!?.rootViewController = loginVC
        UIApplication.shared.delegate?.window!!.makeKeyAndVisible()
    }
    
   
    
    @objc func showSpinningWheel(notification: NSNotification)
    {
        self.uploadimage.isHidden = false
        self.editbutton.isHidden = false
        self.uploadimage.image = notification.userInfo?["image"] as? UIImage
    }
    
    func setupSideMenu()
    {
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = CGFloat(0)
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        // Do any additional setup after loading the view.
        
    }
    @IBAction func onetoonebuttonaction(_ sender: Any)
    {
        let vc:AddVideoVC = self.storyboard?.instantiateViewController(withIdentifier:"AddVideoVC") as! AddVideoVC
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    @IBAction func selectbuttonaction(_ sender: Any) {
        
        var parameters = [String:Any]()
        
        if  uploadimage.image == nil
        {
            self.showToast(message:"Please Select the image")
        }
        else if self.selectrecipientTF.text == "Select Recipient"
        {
            self.showToast(message:"Please Select The Recipient")
        }
        else if self.titleTF.text?.isEmpty == true
        {
             self.showToast(message:"Please Enter Title")
        }
        else if self.messageTextView.text?.isEmpty == true
        {
            self.showToast(message:"Please Enter Message")
        }
        else if self.selectduedate.titleLabel?.text == "Select Due Date"
        {
            self.showToast(message:"Please Select The DueDate")
        }
       
        else
        {
            let showDate = formattedDateFromString(dateString:(self.selectduedate.titleLabel?.text)!, withFormat:"yyyy-MM-dd")
            parameters["image"] = uploadimage.image
            parameters["title"] = self.titleTF.text
            parameters["message"] = self.messageTextView.text
            parameters["duedate"] = showDate
            if self.selectrecipientTF.tag != 0
            {
                parameters["recipient_name"] = self.selectrecipientTF.text
                parameters["recipient_id"] = "\(self.selectrecipientTF.tag)"
            }
            else
            {
                parameters["recipient_name"] = self.selectrecipientTF.text
                parameters["recipient_id"] = "0"
            }
            
            let vc:SelectFriendsVC = self.storyboard?.instantiateViewController(withIdentifier:"SelectFriendsVC") as! SelectFriendsVC
            vc.parameters = parameters
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func addphotobuttonaction(_ sender: Any)
    {
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "AddPhotoVC") as? AddPhotoVC else { return }
        popupVC.popupDelegate = self
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func selectRecipientbuttonaction(_ sender: Any)
    {
        let vc:ChooseFriendVC = self.storyboard?.instantiateViewController(withIdentifier:"ChooseFriendVC") as! ChooseFriendVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func showDatePicker(_ sender:UIButton)
    {
    
        let index = 0
        if datePicker == nil {
            
            let picker = UDatePicker(frame: view.frame, willDisappear: {date in
                if let date = date
                {
                    self.date = date as Date
                    let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.dateStyle = .medium
                    sender.setTitleColor(UIColor.black, for:UIControl.State())
                    sender.setTitle(dateFormatter.string(from: date as Date), for: UIControl.State())
                }
            })
        
            switch index
            {
            case 1:
                picker.picker.datePicker.maximumDate = Date()
                picker.picker.datePicker.locale = Locale(identifier: "zh_CN")
                picker.picker.doneButton.setTitle("carry out", for: UIControl.State())
            case 2:
                picker.picker.doneButton.setTitleColor(UIColor.red, for: UIControl.State())
                picker.picker.datePicker.backgroundColor = UIColor.groupTableViewBackground
                picker.picker.datePicker.datePickerMode = .time
                picker.modalTransitionStyle = .flipHorizontal
            default:
                break
            }
            datePicker = picker
        }
        datePicker!.picker.date = date
        datePicker!.present(self)
    }
    
    
        
    }


extension CreateGreetingsViewController: BottomPopupDelegate {
    
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

extension CreateGreetingsViewController:UITextViewDelegate
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
        if textView.textColor == UIColor.lightGray {
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

extension UITextView{
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
}
