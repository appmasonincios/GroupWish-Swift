//
//  FilterPopupViewController.swift
//  GroupWiish
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class FilterPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func dueTodayAction(_ sender: Any)
    {
          dismiss(animated: true, completion: nil)
        
         let typeoftab = getSharedPrefrance(key:Constants.TABTYPE)
          let nc = NotificationCenter.default
        if typeoftab == "1"
        {
            nc.post(name: Notification.Name(Constants.FILTERDUETODAY + Constants.MyGREETINGMODELCLASS), object: nil)
        }
        else if typeoftab == "2"
        {
            
        }
        else if typeoftab == "3"
        {
            
        }
        else if typeoftab == "4"
        {
            
        }
        else
        {
            nc.post(name: Notification.Name(Constants.FILTERDUETODAY + Constants.NOTIFICATIONCLASS), object: nil)
        }
    }
    
    @IBAction func pastDueAction(_ sender: Any)
    {
        
          dismiss(animated: true, completion: nil)
        
        let typeoftab = getSharedPrefrance(key:Constants.TABTYPE)
        let nc = NotificationCenter.default
        if typeoftab == "1"
        {
            nc.post(name: Notification.Name(Constants.PASTDUE + Constants.MyGREETINGMODELCLASS), object: nil)
        }
        else if typeoftab == "2"
        {
            
        }
        else if typeoftab == "3"
        {
            
        }
        else if typeoftab == "4"
        {
            
        }
        else
        {
            nc.post(name: Notification.Name(Constants.PASTDUE + Constants.NOTIFICATIONCLASS), object: nil)
        }
    }
    
    @IBAction func closeAction(_ sender: Any)
    {
        dismiss(animated: true)
    }
    
}
