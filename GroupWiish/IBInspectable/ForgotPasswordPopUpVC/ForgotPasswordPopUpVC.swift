//
//  ForgotPasswordPopUpVC.swift
//  GroupWiish
//
//  Created by apple on 06/03/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class ForgotPasswordPopUpVC: BottomPopupViewController {

    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func getPopupHeight() -> CGFloat {
        return 180
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
    


}

