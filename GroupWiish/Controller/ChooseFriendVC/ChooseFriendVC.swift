//
//  ChooseFriendVC.swift
//  GroupWiish
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import Alamofire
import ViewAnimator
import PopItUp
class ChooseFriendVC: UIViewController {

    @IBOutlet weak var searchView: GradientView!
    @IBOutlet var searchtextfield: UITextField!
    @IBOutlet weak var collectionview: UICollectionView!
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    @IBOutlet weak var gradientView: GradientView!
    private let image = UIImage(named: "friends-inactive")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = ""
    private let bottomMessage = "No Friends Found"
    
    var myContactsModelClassdata = [MyContactsModelClass]()
     var searchedArray = [MyContactsModelClass]()
      var booleancheck:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

       getfriendslist()
        let flowLayout = CustomImageHorizontalFlowLayout()
        self.collectionview.collectionViewLayout = flowLayout
        
        gradientView.colors = [
            UIColor(red: 91.0/255.0, green: 37.0/255.0, blue: 91.0/255.0, alpha: 1),
            UIColor(red: 111.0/255.0, green: 63.0/255.0, blue: 111.0/255.0, alpha: 1)
        ]
        //  self.searchtextfield.delegate = self
        self.searchtextfield.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        setupEmptyBackgroundView()
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
        self.collectionview.reloadData()
    }
    func setupEmptyBackgroundView()
    {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.collectionview.backgroundView = emptyBackgroundView
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
        
        collectionview.reloadData()
    }
    
   
    
    func getfriendslist()
    {
        executeGET(view: self.view, path: Constants.LIVEURL + Constants.user_contacts + "?userid=" + getSharedPrefrance(key:Constants.ID)){ response in
            let status = response["description"].string
            if(status == "success")
            {
                print(response)
                
                self.myContactsModelClassdata.removeAll()
                
                for store in response["data"].arrayValue
                {
                    self.myContactsModelClassdata.append(MyContactsModelClass(json:store.dictionaryObject!)!)
                }
                
                self.collectionview.reloadData()
                UIView.animate(views: self.collectionview.visibleCells, animations: self.animations, completion: {
                    
                })
                
            }
            else
            {
                self.showToast(message:response["errors"].string ?? "")
            }
        }
        
    }
    
    
    
    @IBAction func backbuttonaction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated:false)
    }
    
    
    
    

}

extension ChooseFriendVC:UICollectionViewDelegate,UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if booleancheck == false
        {
            if myContactsModelClassdata.count == 0
            {
                collectionview.backgroundView?.isHidden = false
            } else {
                collectionview.backgroundView?.isHidden = true
            }
            return self.myContactsModelClassdata.count
        }
        else
        {
            if searchedArray.count == 0
            {
                collectionview.backgroundView?.isHidden = false
            } else {
                collectionview.backgroundView?.isHidden = true
            }
            return searchedArray.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell:SelectAFriendCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:"SelectAFriendCollectionViewCell", for:indexPath) as! SelectAFriendCollectionViewCell
        
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
            cell.friendimage.kf.indicatorType = .activity
            cell.friendimage.kf.setImage(with:imageURL)
            //statements using 'constantName'
        } else {
            // the value of someOptional is not set (or nil).
        }
        cell.friendname.text = myContactsModelClass?.username
        cell.subtitlelabel.text = myContactsModelClass?.location

        return cell
}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var parameters = [String:Any]()
        
        var myContactsModelClass:MyContactsModelClass? = nil
        
        if  booleancheck == false
        {
            myContactsModelClass = self.myContactsModelClassdata[indexPath.row]
        }
        else
        {
            myContactsModelClass = self.searchedArray[indexPath.row]
        }
        
        parameters["id"] = myContactsModelClass?.id
        parameters["username"] = myContactsModelClass?.username
        
        NotificationCenter.default.post(name: Notification.Name(Constants.friendnotification), object:nil, userInfo:parameters)
        
         NotificationCenter.default.post(name: Notification.Name(Constants.friendnotification), object:nil, userInfo:parameters)
        
        
        self.navigationController?.popViewController(animated:false)
        
     
    }

}
