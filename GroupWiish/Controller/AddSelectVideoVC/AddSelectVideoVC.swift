//
//  AddSelectVideoVC.swift
//  GroupWiish
//
//  Created by apple on 14/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import MobileCoreServices
class AddSelectVideoVC: BottomPopupViewController {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
   
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func getPopupHeight() -> CGFloat {
        return 180
    }
    
    @IBAction func camerabuttonaction(_ sender: Any)
    {
        openCamera()
    }
    
    @IBAction func gallerybuttonaxction(_ sender: Any)
    {
        openGallary()
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return 10
    }
    
    override func getPopupPresentDuration() -> Double {
        return 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return  true
    }
    
    //MARK: - Open the camera
    func openCamera()
    {
        dismiss(animated: true, completion:
            {
                let nc = NotificationCenter.default
                let tabbartype = getSharedPrefrance(key:Constants.TABTYPE)
                if tabbartype == "3"
                {
                    nc.post(name: Notification.Name(Constants.openCamera1), object: nil)
                }
                else
                {
                    nc.post(name: Notification.Name(Constants.openCamera), object: nil)
                }
        })
    
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary()
    {
        dismiss(animated: true, completion:{
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(Constants.openGallary), object: nil)
        })
    }
    
}

