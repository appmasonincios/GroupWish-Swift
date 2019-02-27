//
//  TestPopupViewController.swift
//  PopItUp
//
//  Created by fritzgerald muiseroux on 16/03/2018.
//  Copyright © 2018 MUISEROUX Fritzgerald. All rights reserved.
//

import UIKit
class TestPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func nobuttonaction(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func yesbuttonaction(_ sender: Any)
    {
     
        dismiss(animated: true, completion: nil)
        
        let typeoftab = getSharedPrefrance(key:Constants.TABTYPE)
        
        if typeoftab == "1"
        {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("UserLoggedOut1"), object: nil)
        }
        else if typeoftab == "2"
        {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("UserLoggedOut2"), object: nil)
        }
        else if typeoftab == "3"
        {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("UserLoggedOut3"), object: nil)
        }
        else if typeoftab == "4"
        {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("UserLoggedOut4"), object: nil)
        }
        else
        {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("UserLoggedOut5"), object: nil)
            
        }
        

    }
    
    
}
