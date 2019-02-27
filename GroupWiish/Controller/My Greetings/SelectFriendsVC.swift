//
//  SelectFriendsVC.swift
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
import PopItUp
class SelectFriendsVC: UIViewController {

    private let image = UIImage(named: "friends-inactive")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = ""
    private let bottomMessage = "No Friends Found"
    @IBOutlet weak var searchView: GradientView!
    @IBOutlet var searchtextfield: UITextField!
    var searchedArray = [MyContactsModelClass]()
    var booleancheck:Bool = false
    var parameters = [String:Any]()
    @IBOutlet weak var selectfriendslabel: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    @IBOutlet weak var gradientView: GradientView!

 var myContactsModelClassdata = [MyContactsModelClass]()
    var myContactsSelectModelClassdata = [MyContactsModelClass]()
    override func viewDidLoad() {
        super.viewDidLoad()

        //  self.searchtextfield.delegate = self
        self.searchtextfield.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        gradientView.colors = topbarcolor()
        searchView.colors = topbarcolor()
       
        let flowLayout = CustomImageHorizontalFlowLayout()
        self.collectionview.collectionViewLayout = flowLayout
        
        setupEmptyBackgroundView()
        // Do any additional setup after loading the view.
    }

    func setupEmptyBackgroundView()
    {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.collectionview.backgroundView = emptyBackgroundView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getdata()
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
    func getdata()
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
    
    @IBAction func shareGreetingbuttonaction(_ sender: Any)
    {
        
        let image = self.parameters["image"] as? UIImage

        if image != nil
        {
             upload(parameter:parameters, image:image!)
        }
        else
        {
            
            self.showToast(message:"Please Select The Image")
        }
    
    }
    
    func upload(parameter:[String:Any],image:UIImage)
    {
        
        if self.myContactsSelectModelClassdata.count <= 13
        {
            
            if self.myContactsSelectModelClassdata.count >= 1
            {
                var idsarray = [String]()
                
                for i in self.myContactsSelectModelClassdata
                {
                    idsarray.append(i.id!)
                }
                let friendsIds:String = idsarray.description
            
                var parameters = [String:Any]()
                parameters["userid"] = getSharedPrefrance(key:Constants.ID)
                parameters["title"] = parameter["title"]
                parameters["message"] = parameter["message"]
                parameters["duedate"] = parameter["duedate"]
                parameters["friendsIds"] = friendsIds
                parameters["recipient_id"] = parameter["recipient_id"]
                parameters["recipient_name"] = parameter["recipient_name"]
                let headers = [
                    "Authorization": getSharedPrefrance(key:Constants.TOKEN)]
                
                let url = Constants.LIVEURL + Constants.insert_greeting
                self.showLoader(view: self.view)
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    for (key, value) in parameters
                    {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    if let imageData = UIImage.jpegData(image)(compressionQuality:0.4)
                    {
                        let r = arc4random()
                        let str = "screenshot"+String(r)+".jpg"
                        
                        let parameterName = "image"
                        multipartFormData.append(imageData, withName:parameterName, fileName:str, mimeType: "image/jpeg")
                    }
                }, usingThreshold: UInt64.init(), to: url, method: .post, headers:headers) { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            
                            self.hideLoader(view: self.view)
                            
                            let Json = (response.result.value as AnyObject?)
                            
                            if let httpStatus = response.response , httpStatus.statusCode == 200 {
                                if response.result.isSuccess {
                                    print(response)
                                    
                                    if let jsonResult = Json as? Dictionary<String, AnyObject> {
                                        print(jsonResult)
                                        if let responeCode = jsonResult["status"] as? Int
                                        {
                                            if  responeCode == Constants.SUCCESS_CODE
                                            {
                                                self.showToast(message:"Uploaded Successfully")
                                                
                                                let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC
                                                if let tabVC = tabVC
                                                {
                                                    self.present(tabVC, animated: false)
                                                    {
                                                        self.showToastWithMessage(message:"Greeting Created Successfully.", onVc:(UIApplication.shared.keyWindow?.rootViewController)!, type:"1")
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                self.showToast(message:"OOPS! Some thing wrong,Please try again..")
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
            else
            {
               self.showToast(message:"Please select a contact.")
            }
        }
        else
        {
            self.showToast(message:"Maximum 13 contacts are allowed.")
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
        self.collectionview.reloadData()
    }
    @IBAction func closebuttonaction(_ sender: Any)
    {
        self.myContactsSelectModelClassdata.removeAll()
        self.selectfriendslabel.text = "Selected (\(self.myContactsSelectModelClassdata.count)) friends"
        self.collectionview.reloadData()
    }

}

extension SelectFriendsVC:UICollectionViewDelegate,UICollectionViewDataSource
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
            return self.searchedArray.count
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
        
       
        let boolean = self.myContactsSelectModelClassdata.contains(where: { element in element.id == myContactsModelClass?.id
            })
        if boolean == true
        {
            
            cell.checkbutton.isSelected = true
        }
        else
        {
            cell.checkbutton.isSelected = false
            
        }
    
        cell.clickbutton.tag = indexPath.row
        cell.clickbutton.addTarget(self, action:#selector(checkbuttonaction), for:.touchUpInside)

        
        return cell
    }
    
    
    
    @objc func checkbuttonaction(sender:UIButton)
    {
    
        let boolean = self.myContactsSelectModelClassdata.contains(where: { element in element.id == self.myContactsModelClassdata[sender.tag].id
        })
        if boolean == true
        {
            self.myContactsSelectModelClassdata.removeAll (where: { element in element.id == self.myContactsModelClassdata[sender.tag].id
            })
            self.collectionview.reloadData()
        }
        else
        {
            self.myContactsSelectModelClassdata.append(self.myContactsModelClassdata[sender.tag])
        }
        
        
        self.selectfriendslabel.text = "Selected (\(self.myContactsSelectModelClassdata.count)) friends"

          self.collectionview.reloadData()
    }

}


