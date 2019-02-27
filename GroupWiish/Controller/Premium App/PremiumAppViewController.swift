//
//  PremiumAppViewController.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class PremiumAppViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func buyAction(_ sender: Any) {
        let iTunesLink = Constants.PREMIUM_APP_STORE_LINK
        if let url = URL(string: iTunesLink) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }


}
