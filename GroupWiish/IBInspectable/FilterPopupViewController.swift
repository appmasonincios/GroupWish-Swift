//
//  FilterPopupViewController.swift
//  GroupWiish
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class FilterPopupViewController: UIViewController {

    @IBOutlet weak var duetoday: ButtonDesign!
    @IBOutlet weak var pastdue: ButtonDesign!
    
    var duetodaycount:Int = 0
    var pastDuecount:Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.duetoday.setTitle("Due Today" + " " + "(" + "\(duetodaycount)" + ")", for: UIControl.State.normal)
         self.pastdue.setTitle("Past Due" + " " + "(" + "\(pastDuecount)" + ")", for: UIControl.State.normal)
    }


    @IBAction func dueTodayAction(_ sender: Any)
    {
        dismiss(animated: true, completion:{
            
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
        })

    }
    
    @IBAction func pastDueAction(_ sender: Any)
    {
        
        dismiss(animated: true, completion:{
            
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
            
            
        })
        
       
    }
    
    @IBAction func closeAction(_ sender: Any)
    {
        dismiss(animated: true)
    }
    
}
