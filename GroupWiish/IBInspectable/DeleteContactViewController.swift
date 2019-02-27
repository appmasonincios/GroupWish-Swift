//
//  DeleteContactViewController.swift
//  GroupWiish
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class DeleteContactViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        mainView.layer.cornerRadius = 5
        mainView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    @IBAction func blockbuttonaction(_ sender: Any)
    {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(Constants.BLOCK), object: nil)
        
    }
    
    @IBAction func deletebuttonaction(_ sender: Any) {
      
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(Constants.DELETE), object: nil)
        
    }
    
}
