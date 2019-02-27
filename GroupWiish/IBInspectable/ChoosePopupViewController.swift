//
//  ChoosePopupViewController.swift
//  GroupWiish
//
//  Created by apple on 22/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class ChoosePopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func chooseGalleryAction(_ sender: Any)
    {
        
        //gallery
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("gallery"), object: nil)
    
        
    }
    
    @IBAction func recordVideoAction(_ sender: Any)
    {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("record"), object: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any)
    {
        self.dismiss(animated:true, completion:nil)
    }
}
