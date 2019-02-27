//
//  SendCardVC.swift
//  GroupWiish
//
//  Created by apple on 26/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class SendCardVC: UIViewController {

    var friend_id:String = ""
    var greeting_id:String = ""
    var video_id:String = ""
    var card_id:String = ""
    
    
    @IBOutlet weak var messageTF: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    
    
   
    @IBAction func cancel(_ sender: Any)
    {
        self.dismiss(animated: true)
        
    }
    
    
    @IBAction func sendbuttonaction(_ sender: Any)
    {
        if self.messageTF.text?.isEmpty == true
        {
            self.showToast(message:"Please Enter Message")
        }
        else
        {
            self.sendCardVC()
            
        }
    }
    
    
    func sendCardVC()
    {
        var parameters = [String:Any]()
        parameters["userid"] = getSharedPrefrance(key:Constants.ID)
        parameters["friend_id"] = getSharedPrefrance(key:"friend_id")
        parameters["greeting_id"] = getSharedPrefrance(key:"greeting_id")
         parameters["video_id"] = getSharedPrefrance(key:"video_id")
        parameters["card_id"] = getSharedPrefrance(key:"card_id")
         parameters["message"] = self.messageTF.text
    
        executePOST(view: self.view, path: Constants.LIVEURL + Constants.insert_cards_data, parameter:parameters){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                  let insert_cards_data = Notification.Name("insert_cards_data")
                  NotificationCenter.default.post(name:insert_cards_data, object: nil)
                
              self.dismiss(animated: true)
            }
            else
            {
                self.showToast(message:response["errors"].string ?? "")
            }
        }
        
        
        
    }
    
    
    

}
