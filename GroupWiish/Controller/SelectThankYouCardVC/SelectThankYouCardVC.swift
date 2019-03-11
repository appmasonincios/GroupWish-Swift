//
//  SelectThankYouCardVC.swift
//  GroupWiish
//
//  Created by apple on 26/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import SideMenu
import Kingfisher
import SwiftyJSON
import Alamofire
import ViewAnimator
import PopItUp
class SelectThankYouCardVC: UIViewController
{
  
    @IBOutlet weak var grandientview: GradientView!
    @IBOutlet weak var collectionview: UICollectionView!
    var show_all_cards = [Show_all_cards]()
    var myVideosModelClass:MyVideosModelClass? = nil
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    override func viewDidLoad() {
        super.viewDidLoad()
         getthank_cardAPI()
         let insert_cards_data = Notification.Name("insert_cards_data")
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotification(notification:)), name: insert_cards_data, object: nil)
        
        self.grandientview.colors = topbarcolor()
        let flowLayout = CustomImageTwoHorizontalFlowLayout()
        self.collectionview.collectionViewLayout = flowLayout
        // Do any additional setup after loading the view.
    }
    
    
    @objc func methodOfReceivedNotification(notification:Notification)
    {
                        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC
                        if let tabVC = tabVC
                        {
                            self.present(tabVC, animated: false)
                            {
                                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "showmessage"), object: nil)
                            }
                        }
    }
    @IBAction func backbuttonaction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated:false)
    }
   
    func getthank_cardAPI()
    {
        executeGET(view: self.view, path: Constants.LIVEURL + Constants.show_all_cards + "?userid=" + getSharedPrefrance(key:Constants.ID)){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                self.show_all_cards.removeAll()
                for store in response["data"].arrayValue
                {
                    self.show_all_cards.append(Show_all_cards(json:store.dictionaryObject!)!)
                }
                self.collectionview.reloadData()
                UIView.animate(views: self.collectionview.visibleCells, animations: self.animations, completion:
                    {
                })
            }
            else
            {
               // self.showToast(message:response["errors"].string ?? "")
            }
        }
    }
}


extension SelectThankYouCardVC:UICollectionViewDelegate,UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return self.show_all_cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:SelectThankYouCardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:"SelectThankYouCardCollectionViewCell", for:indexPath) as! SelectThankYouCardCollectionViewCell
        
        var show_all_cards:Show_all_cards? = nil
        
        show_all_cards = self.show_all_cards[indexPath.row]
        
        if let mainimageURL = show_all_cards?.card_name
        {
            let mainimageURLt = URL(string:Constants.WS_ImageUrl + "/" + "thanku_cards" + "/" + mainimageURL)
            cell.thank_card_image.kf.indicatorType = .activity
            cell.thank_card_image.kf.setImage(with:mainimageURLt)
        }
        else
        {
            cell.thank_card_image.image = UIImage.init(named:"placeHolder.png")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let show_all_card:Show_all_cards = self.show_all_cards[indexPath.row]

        savesharedprefrence(key:"friend_id", value:self.myVideosModelClass?.friend_id ?? "")
        savesharedprefrence(key:"greeting_id", value:self.myVideosModelClass?.greeting_id ?? "")
        savesharedprefrence(key:"video_id", value:self.myVideosModelClass?.id ?? "")
        savesharedprefrence(key:"card_id", value:show_all_card.id ?? "")
        presentPopup(SendCardVC(),
                     animated: true,
                     backgroundStyle: .blur(.dark), // present the popup with a blur effect has background
            constraints: [.leading(16), .trailing(16),.height(180)], // fix leading edge and the width
            transitioning: .slide(.bottom), // the popup come and goes from the left side of the screen
            autoDismiss: false, // when touching outside the popup bound it is not dismissed
            completion: nil)
    
    }
}


