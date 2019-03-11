//
//  SelectContactsViewController.swift
//  GroupWiish
//
//  Created by apple on 23/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import Alamofire
import ViewAnimator
import PopItUp
class SelectContactsViewController1: UIViewController
{
    private let image = UIImage(named: "friends-inactive")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = ""
    private let bottomMessage = "No Notifications Found"
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    @IBOutlet weak var searchView: UIView!
    @IBOutlet var searchtextfield: UITextField!
    @IBOutlet weak var tableview: UITableView!
    var myContactsModelClassdata = [MyContactsModelClass]()
    var searchedArray = [MyContactsModelClass]()
    var booleancheck:Bool = false
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchtextfield.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        setupEmptyBackgroundView()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.user_contactsfun()
    }
    
   

    
    func setupEmptyBackgroundView()
    {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.tableview.backgroundView = emptyBackgroundView
    }
    
    
    @IBAction func backbuttonaction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated:false)
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
    
    @objc func searchRecordsAsPerText(_ textfield:UITextField)
    {
        searchedArray.removeAll()
        if textfield.text?.characters.count != 0
        {
            for strCountry in self.myContactsModelClassdata
            {
                let str = strCountry.username
                let range = str?.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                if range != nil
                {
                    searchedArray.append(strCountry)
                }
            }
        } else {
            searchedArray = self.myContactsModelClassdata
        }
        
        tableview.reloadData()
    }
    
    func user_contactsfun()
    {
        executeGET(view: self.view, path: Constants.LIVEURL + Constants.user_contacts + "?userid=" + getSharedPrefrance(key:Constants.ID)){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                self.myContactsModelClassdata.removeAll()
                for store in response["data"].arrayValue
                {
                 self.myContactsModelClassdata.append(MyContactsModelClass(json:store.dictionaryObject!)!)
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

}

extension SelectContactsViewController1:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if booleancheck == false
        {
            if self.myContactsModelClassdata.count == 0
            {
                tableView.separatorStyle = .none
                tableView.backgroundView?.isHidden = false
            } else {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView?.isHidden = true
            }
           return self.myContactsModelClassdata.count
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
        let cell:SelectContactsTableViewCell = tableView.dequeueReusableCell(withIdentifier:"SelectContactsTableViewCell") as! SelectContactsTableViewCell
        
        var myContactsModelClass:MyContactsModelClass? = nil
        
        if  booleancheck == false
        {
            myContactsModelClass = self.myContactsModelClassdata[indexPath.row]
        }
        else
        {
            myContactsModelClass = self.searchedArray[indexPath.row]
        }
        
        if let constantName = myContactsModelClass?.profile_pic
        {
            let imageURL = URL(string:Constants.WS_ImageUrl + "/" + constantName)!
            cell.contactimage.kf.indicatorType = .activity
            cell.contactimage.kf.setImage(with:imageURL)
        } else {
            // the value of someOptional is not set (or nil).
        }
        cell.contactname.text = myContactsModelClass?.username
       
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        var myContactsModelClass:MyContactsModelClass? = nil
        
        if  booleancheck == false
        {
            myContactsModelClass = self.myContactsModelClassdata[indexPath.row]
        }
        else
        {
            myContactsModelClass = self.searchedArray[indexPath.row]
        }
        
        var dict = [String:Any]()
        
        let username:String = myContactsModelClass?.username ?? ""
        let profile_pic:String = myContactsModelClass?.profile_pic ?? ""
        let id:String = self.myContactsModelClassdata[indexPath.row].id ?? ""
        dict = ["name":username,
        "profile_pic":profile_pic,"id":id]
        NotificationCenter.default.post(name: Notification.Name("SelectContactsViewController"), object: nil, userInfo: dict)
        self.navigationController?.popViewController(animated:false)
    }
}
