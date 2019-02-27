//
//  MyContactsViewController.swift
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
class MyContactsViewController: UIViewController,UIPopoverPresentationControllerDelegate {

    private let image = UIImage(named: "friends-inactive")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = ""
    private let bottomMessage = "No Friends Found"
    
    @IBOutlet weak var searchView: GradientView!
    @IBOutlet var searchtextfield: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var selectimage: UIImageView!
    @IBOutlet weak var contactcollectionview: UICollectionView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var profileimage: UIImageView!
     private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    var booleancheck:Bool = false
     var myContactsModelClassdata = [MyContactsModelClass]()
      var searchedArray = [MyContactsModelClass]()
    var GridAction = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  self.searchtextfield.delegate = self
        self.searchtextfield.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(block), name: Notification.Name(Constants.BLOCK), object: nil)
        nc.addObserver(self, selector: #selector(deletef), name: Notification.Name(Constants.DELETE), object: nil)
          GridAction    = true
         tableview.isHidden = true
         let flowLayout = CustomImageHorizontalFlowLayout()
         self.contactcollectionview.collectionViewLayout = flowLayout
        searchView.colors = topbarcolor()
        gradientView.colors = topbarcolor()
        setupSideMenu()
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        userlogout()
        setupEmptyBackgroundView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       profileimagedisplay()
        savesharedprefrence(key:Constants.TABTYPE, value:"4")
        self.user_contacts()
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
    
    func setupEmptyBackgroundView()
    {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        let emptyBackgroundView1 = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.tableview.backgroundView = emptyBackgroundView
        self.contactcollectionview.backgroundView = emptyBackgroundView1
      //  self.contactcollectionview.backgroundView = emptyBackgroundView
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
        contactcollectionview.reloadData()
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
        self.contactcollectionview.reloadData()
    }
    

    func userlogout()
    {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name("ULO4"), object: nil)
        nc.addObserver(self, selector: #selector(userLoggedIn1), name: Notification.Name("UserLoggedOut4"), object: nil)
    }
    
    
    @objc func userLoggedIn()
    {
        dismiss(animated:true, completion:nil)
        presentPopup(TestPopupViewController(),
                     animated: true,
                     backgroundStyle: .blur(.dark), // present the popup with a blur effect has background
            constraints: [.leading(16), .trailing(16),.height(250)], // fix leading edge and the width
            transitioning: .slide(.left), // the popup come and goes from the left side of the screen
            autoDismiss: false, // when touching outside the popup bound it is not dismissed
            completion: nil)
    }
    
    @objc func deletef()
    {
        let i = getSharedPrefrance(key:Constants.DELETECONTACTOBJ)
        
        let j = Int(i)
    
        var parameter = [String:Any]()
        
        let friendid =  self.myContactsModelClassdata[j ?? 0].id
        
        parameter["friend_id"] = friendid
        parameter["userid"] = getSharedPrefrance(key:Constants.ID)
        
        
        executePOST(view: self.view, path: Constants.LIVEURL + Constants.delete_contact, parameter: parameter){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                 self.showToast(message:"Deleted successfully")
                
                self.user_contacts()
            }
            else
            {
                self.showToast(message:response["errors"].string ?? "")
            }
        }
    
    }
    
    @objc func block()
    {
       // let i = getSharedPrefrance(key:Constants.DELETECONTACTOBJ)
        
       // let j = Int(i)
        
        
        
    }
    
    @IBAction func searchcontactsbuttonaction(_ sender: Any)
    {
        let  vc:AddContactsViewControllern = self.storyboard?.instantiateViewController(withIdentifier:"AddContactsViewControllern") as! AddContactsViewControllern
        self.navigationController?.pushViewController(vc, animated:false)
    }
    
    
    @IBAction func gridtosharebuttonaction(_ sender: Any)
    {
        
        if GridAction == false
        {
            GridAction = true
            tableview.isHidden = true
           contactcollectionview.isHidden = false
            selectimage.image = UIImage(named: "grid-icon")
        }
        else
        {
            GridAction = false
            tableview.isHidden = false
            contactcollectionview.isHidden = true
             selectimage.image = UIImage(named: "list-icon")
        }
    }
    
    @objc func userLoggedIn1()
    {
        savesharedprefrence(key:"loginsession", value:"false")
        logout()
        let sc:SplashScreenViewController = self.storyboard?.instantiateViewController(withIdentifier:"SplashScreenViewController") as! SplashScreenViewController
        self.presentPopup(sc, animated:false)
        
    }
    
    func user_contacts()
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
                self.contactcollectionview.reloadData()
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
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = CGFloat(0)
        
    }
    
    
    
}

extension MyContactsViewController:UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if booleancheck == false
        {
            if self.myContactsModelClassdata.count == 0
            {
                self.contactcollectionview.backgroundView?.isHidden = false
            } else {
                self.contactcollectionview.backgroundView?.isHidden = true
            }
            return self.myContactsModelClassdata.count
        }
        else
        {
            if self.searchedArray.count == 0
            {
                self.contactcollectionview.backgroundView?.isHidden = false
            } else {
                self.contactcollectionview.backgroundView?.isHidden = true
            }
            return self.searchedArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:MyContactsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:"MyContactsCollectionViewCell", for:indexPath) as! MyContactsCollectionViewCell
        
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
            cell.contactimage.kf.setImage(with:imageURL,
                                          placeholder: UIImage(named:"no-user-img.png"),
                                          options: [.transition(ImageTransition.fade(1))],
                                          progressBlock: { receivedSize, totalSize in },
                                          completionHandler: { image, error, cacheType, imageURL in})
        }
        else
        {
            // the value of someOptional is not set (or nil).
        }
        cell.contectname.text = myContactsModelClass?.username
        cell.contactplacelabel.text = myContactsModelClass?.location
        cell.deleteAction.tag = indexPath.row
        cell.deleteAction.addTarget(self, action:#selector(deleteActionContact), for:.touchUpInside)
       
        return cell
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    @objc func deleteActionContact(sender:UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeleteContactViewController") as? DeleteContactViewController
        vc?.modalPresentationStyle = .popover
        vc?.popoverPresentationController?.permittedArrowDirections = .up
        vc?.popoverPresentationController?.delegate                 = self
        vc?.popoverPresentationController?.backgroundColor = UIColor.yellow
        vc?.preferredContentSize = CGSize(width: 120, height: 50)
        vc?.popoverPresentationController?.sourceView = sender
        vc?.popoverPresentationController?.sourceRect = sender.bounds
        present(vc!, animated: true)
        savesharedprefrence(key:Constants.DELETECONTACTOBJ, value:"\(sender.tag)")
    }
  
}


extension MyContactsViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if booleancheck == false
        {
            if myContactsModelClassdata.count == 0
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MycontactsTableViewCell1 = tableView.dequeueReusableCell(withIdentifier:"MycontactsTableViewCell1") as! MycontactsTableViewCell1
        
    
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
            cell.contactimage.kf.setImage(with:imageURL,
                                         placeholder: UIImage(named:"no-user-img.png"),
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in },
                                         completionHandler: { image, error, cacheType, imageURL in})
        } else {
           
        }
        cell.contectname.text = myContactsModelClass?.username
        cell.contactplacelabel.text = myContactsModelClass?.location
        
        cell.deleteAction.tag = indexPath.row
        cell.deleteAction.addTarget(self, action:#selector(deleteActionContact), for:.touchUpInside)
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
