//
//  ReceivedTYCardsVC.swift
//  GroupWiish
//
//  Created by apple on 14/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import Alamofire
import ViewAnimator
import DYBadgeButton
class ReceivedTYCardsVC: UIViewController {

    private let image = UIImage(named: "friends-inactive")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = ""
    private let bottomMessage = "No Cards Found"
    @IBOutlet weak var profilebutton: DYBadgeButton!
    @IBOutlet weak var usernotification: DYBadgeButton!
    @IBOutlet weak var searchView: GradientView!
    @IBOutlet var searchtextfield: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var profileimage: ImageViewDesign!
    @IBOutlet weak var gradientView: GradientView!
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    var get_Friend_Cards = [Get_Friend_Cards]()
      var searchedArray = [Get_Friend_Cards]()
      var booleancheck:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        savesharedprefrence(key:Constants.menunumber, value:"4")
       
       
        self.searchtextfield.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        gradientView.colors = topbarcolor()
        searchView.colors = topbarcolor()
        profileimagedisplay()
      setupEmptyBackgroundView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        profileimagedisplay()
        getdata()
        self.bedgecountapi()
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
    
    func profileimagedisplay()
    {
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

    @IBAction func profilebuttonaclicked(_ sender: Any)
    {
        self.profileclicked()
    }
    
    @IBAction func notificationbuttonaction(_ sender: Any)
    {
        self.requestViewController()
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
            for strCountry in self.get_Friend_Cards
            {
                let str = strCountry.friend_name
                let range = str?.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                if range != nil
                {
                    searchedArray.append(strCountry)
                }
            }
        } else {
            searchedArray = self.get_Friend_Cards
        }
        
        tableview.reloadData()
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
    
    func getdata()  {

        let urlString = Constants.LIVEURL + Constants.get_friend_cards + "?user_id=" + getSharedPrefrance(key:Constants.ID)
        
        executeGET(view: self.view, path:urlString)
        { response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                self.get_Friend_Cards.removeAll()
                for store in response["data"].arrayValue
                {
                  self.get_Friend_Cards.append(Get_Friend_Cards(json:store.dictionaryObject!)!)
                }
                self.tableview.reloadData()
                UIView.animate(views: self.tableview.visibleCells, animations: self.animations, completion: {
                })
            }
            else
            {
                //self.showToast(message:response["errors"].string ?? "")
            }
        }
    }

    @IBAction func profilebuttonaction(_ sender: Any)
    {
        self.profileclicked()
    }
    @IBAction func requestbuttonaction(_ sender: Any)
    {
        self.requestViewController()
    }
    
    @IBAction func backbuttonaction(_ sender: Any)
    {
    self.navigationController?.popViewController(animated:false)
    }
    
}


extension ReceivedTYCardsVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if booleancheck == false
        {
            if get_Friend_Cards.count == 0
            {
            tableView.backgroundView?.isHidden = false
            } else {
                tableView.backgroundView?.isHidden = true
            }
            return self.get_Friend_Cards.count
        }
        else
        {
            if searchedArray.count == 0
            {
                tableView.backgroundView?.isHidden = false
            } else {
                tableView.backgroundView?.isHidden = true
            }
            return searchedArray.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ReceivedTYCardsTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ReceivedTYCardsTableViewCell") as! ReceivedTYCardsTableViewCell
        
        var get_Friend_Cards:Get_Friend_Cards? = nil
        
        if  booleancheck == false
        {
            get_Friend_Cards = self.get_Friend_Cards[indexPath.row]
        }
        else
        {
            get_Friend_Cards = self.searchedArray[indexPath.row]
        }
    
        if let friendpic = get_Friend_Cards?.friend_pic
        {
            let imageURL = URL(string:Constants.WS_ImageUrl + "/" + friendpic)!
            cell.userimage.kf.indicatorType = .activity
            cell.userimage.kf.setImage(with: imageURL)
        }
        cell.username.text = get_Friend_Cards?.friend_name
        cell.datelabel.text = get_Friend_Cards?.datetime
    
        if let card_name = get_Friend_Cards?.card_name
        {
            let imageURL1 = URL(string:Constants.WS_ImageUrl + "/" + "thanku_cards" + "/" + card_name)!
            cell.cardimage.kf.indicatorType = .activity
            cell.cardimage.kf.setImage(with:imageURL1)
        }
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(self.deleteThankCard(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteThankCard(_ sender: UIButton?)
    {
        tag_deleteThankCard(user_id:getSharedPrefrance(key:Constants.ID), card_id:"\(sender?.tag ?? 0)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 300
    }
    
    func tag_deleteThankCard(user_id:String,card_id:String)
    {
        let  urlString = "\(Constants.LIVEURL)/\(Constants.delete_card)?user_id=\(getSharedPrefrance(key:Constants.ID))&card_id=\(card_id)"
     
        executeGET(view: self.view, path:urlString)
        { response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                self.getdata()
            }
            else
            {
               // self.showToast(message:response["errors"].string ?? "")
            }
        }
        
        
        
        
    }
  
}
