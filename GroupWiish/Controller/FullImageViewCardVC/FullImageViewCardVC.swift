//
//  FullImageViewCardVC.swift
//  GroupWiish
//
//  Created by apple on 26/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import Alamofire
class FullImageViewCardVC: UIViewController {

    var video_id:String? = nil
    var thankyoucardimagedata:Thankyoucardimagedata? = nil
    
     @IBOutlet weak var simpleilabel:UILabel!
    @IBOutlet weak var simpleimage: UIImageView!
    @IBOutlet weak var gradientview: GradientView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gradientview.colors = topbarcolor()
      displayimageapi()
    }
    
    
    @IBAction func backbuttonaction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated:false)
    }
    
    func displayimageapi()
    {
        
        executeGET(view: self.view, path: Constants.LIVEURL + Constants.get_host_card + "?video_id=" + self.video_id!)
        { response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {

                self.thankyoucardimagedata = Thankyoucardimagedata(json:response["data"].dictionaryObject!)
                let mainimageURL = self.thankyoucardimagedata?.card_name
                  let simplemessage = self.thankyoucardimagedata?.message
                
                
                if let image = mainimageURL
                {
                    let mainimageURLt = URL(string:Constants.WS_ImageUrl + "/" + "thanku_cards" + "/" + image)
                    self.simpleimage.kf.indicatorType = .activity
                    self.simpleimage.kf.setImage(with:mainimageURLt)
                }
                
                self.simpleilabel.text = simplemessage
              
              
            }
            else
            {
                self.showToast(message:response["errors"].string ?? "")
            }
        }
        
    }
    

  

}
