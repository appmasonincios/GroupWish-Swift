//
//  AddContactsViewController.swift
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
import SearchTextField
import DYBadgeButton
class AddContactsViewControllern: UIViewController {

    @IBOutlet weak var searchicon: UIImageView!
    @IBOutlet weak var searchviewinstackview: UIView!
    @IBOutlet weak var profilebutton: DYBadgeButton!
    @IBOutlet weak var usernotification: DYBadgeButton!
     @IBOutlet weak var firstbutton: UIButton!
    @IBOutlet weak var secondbutton: UIButton!
    @IBOutlet weak var thirdbutton: UIButton!
    @IBOutlet weak var stackview: UIView!
    @IBOutlet weak var menuview: UIView!
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    @IBOutlet weak var noDataLbl: UIStackView!
    @IBOutlet weak var profileimage: ImageViewDesign!
    @IBOutlet weak var gradientview: GradientView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF1: SearchTextField!
    @IBOutlet weak var friendsLbl: UILabel!
    @IBOutlet weak var searchbutton: UIButton!
    var search_contactsModelClass = [Search_contactsModelClass]()
    var search_contactsModelClassOrginal = [Search_contactsModelClass]()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.firstbutton.isSelected = true
        self.secondbutton.isSelected = false
        self.thirdbutton.isSelected = false
        
        self.searchfriend(criteria:"")
        
         profileimagedisplay()
        gradientview.colors = topbarcolor()
        configureCustomSearchTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
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
    
   
    @IBAction func firstbuttonaction(_ sender: Any)
    {
        self.firstbutton.isSelected = true
        self.secondbutton.isSelected = false
        self.thirdbutton.isSelected = false
        
        self.search_contactsModelClass.removeAll()
        for item in self.search_contactsModelClassOrginal
        {
            if item.is_friend == 2
            {
                self.search_contactsModelClass.append(item)
            }
        }

        if self.search_contactsModelClass.count == 0
        {
            self.noDataLbl.isHidden = false
        }
        else
        {
            self.noDataLbl.isHidden = true
        }
        self.tableview.reloadData()
        
       
    }
    
    @IBAction func secondbuttonaction(_ sender: Any)
    {
        self.firstbutton.isSelected = false
        self.secondbutton.isSelected = true
        self.thirdbutton.isSelected = false
        
        self.search_contactsModelClass.removeAll()
        for item in self.search_contactsModelClassOrginal
        {
            if item.is_friend == 1
            {
                self.search_contactsModelClass.append(item)
            }
        }
        if self.search_contactsModelClass.count == 0
        {
            self.noDataLbl.isHidden = false
        }
        else
        {
            self.noDataLbl.isHidden = true
        }
        self.tableview.reloadData()
        
    }
    @IBAction func thirdbuttonaction(_ sender: Any)
    {
        self.firstbutton.isSelected = false
        self.secondbutton.isSelected = false
        self.thirdbutton.isSelected = true
        
        self.search_contactsModelClass.removeAll()
        for item in self.search_contactsModelClassOrginal
        {
            if item.is_friend == 0
            {
                self.search_contactsModelClass.append(item)
            }
        }
        if self.search_contactsModelClass.count == 0
        {
            self.noDataLbl.isHidden = false
        }
        else
        {
            self.noDataLbl.isHidden = true
        }
        self.tableview.reloadData()

    }
    
    @IBAction func searchCancelTap(_ sender: Any)
    {
        self.friendsLbl.isHidden = false
        self.searchbutton.isHidden = false
        self.searchicon.isHidden = false
        self.searchView.isHidden = true
        self.searchTF1.text = ""
        self.stackview.isHidden = false
        self.menuview.isHidden = false
        self.searchTF1.resignFirstResponder()
    }
    
    
    @IBAction func searchTapped(_ sender: Any)
    {
      
        self.searchicon.isHidden = true
        self.searchbutton.isHidden = true
        self.friendsLbl.isHidden = true
        self.searchView.isHidden = false
       self.stackview.isHidden = false
      self.menuview.isHidden = true
    }
   
    
    @IBAction func invitebuttonaction(_ sender: Any)
    {
        inviteFrndsTap()
    }
    func inviteFrndsTap()
    {
        let textToShare = "Hey there - Download FREE Groupwiish app from <a href='\(Constants.LIVEURL)'>\(Constants.LIVEURL)</a>. <br><br> How it works - <a href='\(Constants.WS_VideoUrl)'>\(Constants.WS_VideoUrl)</a>. <br><br> Best Wishes."
    
        var shareAll = [Any]()
        shareAll = [textToShare]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    // 2 - Configure a custom search text view
    fileprivate func configureCustomSearchTextField() {
        // Set theme - Default: light
        searchTF1.theme = SearchTextFieldTheme.lightTheme()
        
        // Define a header - Default: nothing
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: searchTF1.frame.width, height: 30))
        header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        header.textAlignment = .center
        header.font = UIFont.systemFont(ofSize: 14)
        header.text = "Pick your option"
        searchTF1.resultsListHeader = header
        
        // Modify current theme properties
        searchTF1.theme.font = UIFont.systemFont(ofSize: 12)
        searchTF1.theme.bgColor = UIColor.lightGray.withAlphaComponent(0.2)
        searchTF1.theme.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        searchTF1.theme.separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
        searchTF1.theme.cellHeight = 50
        searchTF1.theme.placeholderColor = UIColor.lightGray
        
        // Max number of results - Default: No limit
        searchTF1.maxNumberOfResults = 5
        
        // Max results list height - Default: No limit
        searchTF1.maxResultsListHeight = 200
        
        // Set specific comparision options - Default: .caseInsensitive
        searchTF1.comparisonOptions = [.caseInsensitive]
        
        // You can force the results list to support RTL languages - Default: false
        searchTF1.forceRightToLeft = false
        
        // Customize highlight attributes - Default: Bold
        searchTF1.highlightAttributes = [NSAttributedString.Key.backgroundColor: UIColor.yellow, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
        
        // Handle item selection - Default behaviour: item title set to the text field
        searchTF1.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print("Item at position \(itemPosition): \(item.title)")
            
            // Do whatever you want with the picked item
            self.searchTF1.text = item.title
        }
        
        // Update data source when the user stops typing
        searchTF1.userStoppedTypingHandler = {
            if let criteria = self.searchTF1.text {
                if criteria.count > 1 {
                    
                    // Show loading indicator
                    self.searchTF1.showLoadingIndicator()
                    
                    self.filterAcronymInBackground(criteria) { results in
                        
                        // Set new items to filter
                        self.searchTF1.filterItems(results)
                        
                        // Stop loading indicator
                        self.searchTF1.stopLoadingIndicator()
                    }
                }
            }
            } as (() -> Void)
    }

    fileprivate func filterAcronymInBackground(_ criteria: String, callback: @escaping ((_ results: [SearchTextFieldItem]) -> Void))
    {
        self.searchfriend(criteria:criteria)
    }
    
    
    func searchfriend(criteria: String)
    {
      
        let urlString = "\(Constants.LIVEURL)/\(Constants.search_contacts)?userid=\(getSharedPrefrance(key:Constants.ID))&name=\(criteria)"
        executeGET(view: self.view, path:urlString)
        { response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                self.searchTF1.resignFirstResponder()
                self.search_contactsModelClass.removeAll()
                self.search_contactsModelClassOrginal.removeAll()
                
                for store in response["data"].arrayValue
                {
                    self.search_contactsModelClassOrginal.append(Search_contactsModelClass(json:store.dictionaryObject!)!)
                }
                
                if self.firstbutton.isSelected == true
                {
                    self.firstbutton.isSelected = true
                    self.secondbutton.isSelected = false
                    self.thirdbutton.isSelected = false
                    
                    for item in self.search_contactsModelClassOrginal
                    {
                        if item.is_friend == 2
                        {
                            self.search_contactsModelClass.append(item)
                        }
                    }
                }
                else if self.secondbutton.isSelected == true
                {
                    self.firstbutton.isSelected = false
                    self.secondbutton.isSelected = true
                    self.thirdbutton.isSelected = false
                    
                    self.search_contactsModelClass.removeAll()
                    for item in self.search_contactsModelClassOrginal
                    {
                        if item.is_friend == 1
                        {
                            self.search_contactsModelClass.append(item)
                        }
                    }
                }
                else
                {
                    self.firstbutton.isSelected = false
                    self.secondbutton.isSelected = false
                    self.thirdbutton.isSelected = true
                    
                    self.search_contactsModelClass.removeAll()
                    for item in self.search_contactsModelClassOrginal
                    {
                        if item.is_friend == 0
                        {
                            self.search_contactsModelClass.append(item)
                        }
                    }
                }
                if self.search_contactsModelClass.count == 0
                {
                    self.noDataLbl.isHidden = false
                }
                else
                {
                self.noDataLbl.isHidden = true
                }
                self.tableview.reloadData()
            }
            else
            {
                self.showToast(message:response["errors"].string ?? "")
            }
        }
    }
    
    @objc func addfriendbuttonaction(_ sender:UIButton)
    {
        let is_friend = self.search_contactsModelClass[sender.tag].id!
        let urlString = Constants.LIVEURL + Constants.SEND_FRIEND_REQUEST
        
        var parameters = [String:Any]()
        parameters["userid"] = getSharedPrefrance(key:Constants.ID)
        parameters["friend_id"] =  is_friend
        
        
        executePOST(view: self.view, path:urlString, parameter:parameters){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                self.showToast(message:"Request Sent Successfully")
                
                self.searchfriend(criteria:self.searchTF1.text ?? "")
    
            }
            else
            {
               
            }
        }
        
        
        
    }
    
    
    
    @IBAction func backbuttonaction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated:false)
    }
}

extension AddContactsViewControllern:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return search_contactsModelClass.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AddFriendTableViewCell = tableView.dequeueReusableCell(withIdentifier:"AddFriendTableViewCell", for:indexPath) as! AddFriendTableViewCell
        
        let search_contactsModelClass:Search_contactsModelClass = self.search_contactsModelClass[indexPath.row]
        
        
        if let constantName = search_contactsModelClass.profile_pic
        {
            let imageURL = URL(string:Constants.WS_ImageUrl + "/" + constantName)!

            cell.grettingprofileimage.kf.indicatorType = .activity
            cell.grettingprofileimage.kf.setImage(with:imageURL)
            //statements using 'constantName'
        }
        else
        {
            // the value of someOptional is not set (or nil).
        }
  
        cell.username.text = search_contactsModelClass.username

         cell.addfriendbutton.isHidden = true
        
        if search_contactsModelClass.is_friend == 0
        {
            cell.addfriendbutton.isHidden = false
        }
        else if search_contactsModelClass.is_friend == 1
        {
             cell.addfriendbutton.isHidden = false
        }
        else
        {
             cell.addfriendbutton.isHidden = true
        }
        
        
       cell.addfriendbutton.tag = indexPath.row
        
      
        cell.addfriendbutton.addTarget(self, action:#selector(addfriendbuttonaction), for:.touchUpInside)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 80
    }
    
  
    
}


