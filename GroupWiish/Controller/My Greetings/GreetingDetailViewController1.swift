//
//  GreetingDetailViewController.swift
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
import DYBadgeButton
class GreetingDetailViewController1: UIViewController {

   
    @IBOutlet weak var videocountlabel: UILabel!
    @IBOutlet weak var profilebutton: DYBadgeButton!
    @IBOutlet weak var usernotification: DYBadgeButton!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var titleMsg: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var selectedFrndsLbl: UILabel!
    @IBOutlet weak var frndsTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet var tKparllax: TKParallaxScrollView!
    @IBOutlet weak var profileimage: ImageViewDesign!
    @IBOutlet weak var gradientView: GradientView!
    var greetDataClass:Greet_dataClass? = nil
    var myGreetingsModel:MyGreetingsModelClass? = nil
    var friends_dataModelClass = [Friends_dataModelClass]()
    var greeting_id = ""
    var id = ""
    var videosCount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileimagedisplay()
        self.gradientView.colors = topbarcolor()
            bedgecountapi()
        
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
    override func viewWillAppear(_ animated: Bool) {
        
        getdatagreetingDetails()
    }
    @IBAction func backbuttonaction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated:false)
    }
    
    func getdatagreetingDetails()
    {
       let object = getSharedPrefrance(key:Constants.ID)
        let object1 = self.id

        let urlString = "\(Constants.LIVEURL)\(Constants.get_greeting_details)?userid=\(object)&greeting_id=\(object1)"
    
            executeGET(view: self.view, path:urlString){ response in
                let status = response["status"].int
                if(status == Constants.SUCCESS_CODE)
                {
                    self.greetDataClass = Greet_dataClass(json:response["data"]["greet_data"].dictionaryObject!)!
                    if let constantName = self.greetDataClass?.image
                    {
                        let imageURL = URL(string:Constants.WS_ImageUrl + "/" + constantName)!
                        self.userImage.kf.indicatorType = .activity
                        self.userImage.kf.setImage(with:imageURL)
                    } else
                    {
                    }
                        self.videocountlabel.text = self.greeting_id
                    self.titleMsg.text = self.greetDataClass?.title
                    self.messageLbl.text = self.greetDataClass?.message
                    self.dateLbl.text = self.greetDataClass?.duedate
                    for store in response["data"]["friends_data"].arrayValue
                    {
                        self.friends_dataModelClass.append(Friends_dataModelClass(json:store.dictionaryObject!)!)
                    }
                    self.mainViewHeight.constant = CGFloat(700 + self.friends_dataModelClass.count * 100)
                    self.frndsTableView.reloadData()
                }
                else
                {
                    self.showToast(message:response["errors"].string ?? "")
                }
            }
    }
}

extension GreetingDetailViewController1:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String?
    {
        switch(section)
        {
        case 0:
             return "Selected Recipient"
        case 1:
            return "Tagged Friends"
            
        default :return ""
            
        }
    }
    
    private func tableView (_ tableView:UITableView , heightForHeaderInSection section:Int)->Float
    {
        let title = self.tableView(tableView, titleForHeaderInSection: section)
        if (title == "")
        {
            return 0.0
        }
        return 0.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if section == 0
        {
           return 1
        }
        else
        {
            return self.friends_dataModelClass.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell:GreetingsDetailstwoTableViewCell = tableView.dequeueReusableCell(withIdentifier:"GreetingsDetailstwoTableViewCell") as! GreetingsDetailstwoTableViewCell
    
        if indexPath.section == 0
        {
            if let name = self.greetDataClass?.recipient_name
            {
                   cell.friendname.text = name
                   cell.friendnamelabel.text = name
                   cell.friendname.isHidden = true
            }
            else
            {
                cell.friendname.text = ""
            }
           cell.videostatus.isHidden = true
           cell.locationlabel.isHidden = true
           cell.heightoftop.constant = 16
        }
        else
        {
             cell.locationlabel.isHidden = false
            cell.heightoftop.constant = 16
            
            if let constantName = self.friends_dataModelClass[indexPath.row].profile_pic
            {
                let imageURL = URL(string:Constants.WS_ImageUrl + "/" + constantName)!
                
                cell.friendimage.kf.setImage(with:imageURL,
                                         placeholder: UIImage(named:"default.png"),
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in },
                                         completionHandler: { image, error, cacheType, imageURL in})
            }
            else
            {
        
            }
             cell.friendnamelabel.isHidden = true
            cell.videostatus.isHidden = false
        
            if self.friends_dataModelClass[indexPath.row].is_video == 1
            {
                cell.videostatus.text = "Video Received"
            }
            else
            {
                cell.videostatus.text = "Video Pending"
            }
            cell.locationlabel.text = self.friends_dataModelClass[indexPath.row].location
            cell.friendname.text = self.friends_dataModelClass[indexPath.row].username
        }
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 70.0
        }
        else
        {
            return 89.0
        }
    }
}
