//
//  RequestViewController.swift
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
class RequestViewController: UIViewController
{
    @IBOutlet weak var profilebutton: DYBadgeButton!
    @IBOutlet weak var usernotification: DYBadgeButton!
    private let image = UIImage(named: "friends-inactive")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = ""
    private let bottomMessage = "No Friends Found"
     @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var profileimage: UIImageView!
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    //MyContactsModelClass
    var get_Friend_RequestsModelClass = [Get_Friend_RequestsModelClass]()
    var booleancheck:Bool = false
    var searchedArray = [Get_Friend_RequestsModelClass]()
    @IBOutlet weak var searchView: GradientView!
    @IBOutlet var searchtextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchView.colors = topbarcolor()
        self.searchtextfield.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
         profileimagedisplay()
        gradientView.colors = topbarcolor()
        get_friend_requests()
        
        setupEmptyBackgroundView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
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
            for strCountry in self.get_Friend_RequestsModelClass
            {
                let str = strCountry.username
                let range = str?.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                if range != nil
                {
                    searchedArray.append(strCountry)
                }
            }
        }
        else
        {
            searchedArray = self.get_Friend_RequestsModelClass
        }
        
        tableview.reloadData()
    }

    @IBAction func backbuttonaction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated:false)
    }

    func get_friend_requests()
    {
        
       
            self.get_Friend_RequestsModelClass.removeAll()
           self.searchedArray.removeAll()
        
       let urlstring = "\(Constants.LIVEURL)\(Constants.get_friend_requests)?userid=\(getSharedPrefrance(key:Constants.ID))"
       
        executeGET(view: self.view, path:urlstring){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                for store in response["data"].arrayValue
                {
        self.get_Friend_RequestsModelClass.append(Get_Friend_RequestsModelClass(json:store.dictionaryObject!)!)
                }
               self.tableview.reloadData()
                
            }
            else
            {
                self.tableview.reloadData()
           // self.showToast(message:response["errors"].string ?? "")
            }
        }
    }
    
    @objc func acceptbtnTapped(_ sender: UIButton?) {
       
        let friend = self.get_Friend_RequestsModelClass[sender?.tag ?? 0].id
        var dic: [String : Any] = [:]
        dic["request_id"] = friend
        dic["userid"] = getSharedPrefrance(key:Constants.ID)
        dic["response"] = "1"
     
        self.request_response(parameter:dic)
    }
    
    @objc func cancelbtnTapped(_ sender: UIButton?)
    {
        let friend = String(format: "%li", Int(sender?.tag ?? 0))
        var dic: [String : Any] = [:]
        dic["request_id"] = friend
        dic["userid"] = getSharedPrefrance(key:Constants.ID)
        dic["response"] = "0"
        
        self.request_response(parameter:dic)
    }
    
    func request_response(parameter:[String:Any])
    {
      
        executePOST(view: self.view, path: Constants.LIVEURL + Constants.request_response + "?userid=" + getSharedPrefrance(key:Constants.ID), parameter:parameter){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                 self.showToast(message:"Request Accepted Successful")
                
                self.get_friend_requests()
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
        
}

extension RequestViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if booleancheck == false
        {
            if get_Friend_RequestsModelClass.count == 0
            {
                
                tableView.backgroundView?.isHidden = false
            } else {
                tableView.backgroundView?.isHidden = true
            }
            return self.get_Friend_RequestsModelClass.count
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
        
        let cell:RequestViewTableViewCell = tableView.dequeueReusableCell(withIdentifier:"RequestViewTableViewCell") as! RequestViewTableViewCell
        
        
        var get_Friend_RequestsModelClass:Get_Friend_RequestsModelClass? = nil
        
        if booleancheck == false
        {
            get_Friend_RequestsModelClass = self.get_Friend_RequestsModelClass[indexPath.row]
        }
        else
        {
            get_Friend_RequestsModelClass = self.searchedArray[indexPath.row]
        }
        
        if let profile_pic = get_Friend_RequestsModelClass?.profile_pic
        {
            let imageURL = URL(string:Constants.WS_ImageUrl + "/" + profile_pic)!
            
            cell.userImageView.kf.setImage(with:imageURL,
                                          placeholder: UIImage(named:"no-user-img.png"),
                                          options: [.transition(ImageTransition.fade(1))],
                                          progressBlock: { receivedSize, totalSize in },
                                          completionHandler: { image, error, cacheType, imageURL in})
          
        }
        
        cell.nameLbl.text = get_Friend_RequestsModelClass?.username
        cell.location.text = get_Friend_RequestsModelClass?.location
        cell.acceptbtn.tag = indexPath.row
        cell.cancelBtn.tag = indexPath.row

        cell.acceptbtn.addTarget(self, action: #selector(self.acceptbtnTapped(_:)), for: .touchUpInside)
        cell.cancelBtn.addTarget(self, action: #selector(self.cancelbtnTapped(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    
    
}
