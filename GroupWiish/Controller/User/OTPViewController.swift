//
//  OTPViewController.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController,SDOtpFieldDelegate {
 @IBOutlet weak var otpField: SDOtpField!
    override func viewDidLoad() {
        super.viewDidLoad()

         otpField.numberOfDigits = 4
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        otpField.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getResults(_ sender: Any) {
      //  displayLabel.text = otpField.currentOtp
        otpField.clearOTPText()
        otpField.resignFirstResponder()
    }

}
