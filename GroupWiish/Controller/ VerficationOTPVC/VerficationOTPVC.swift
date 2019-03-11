//
//  VerficationOTPVC.swift
//  GroupWiish
//
//  Created by apple on 08/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class VerficationOTPVC: UIViewController,SDOtpFieldDelegate {

    @IBOutlet weak var otptextfield: SDOtpField!
    @IBOutlet weak var emailabel: UILabel!
     var someDict = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

          otptextfield.numberOfDigits = 4
      
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        otptextfield.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func verificationcode(_ sender: Any)
    {
    
    let id:String = (someDict["id"] as? String)!
    
    let parameter:[String:Any] = [
    "userid":id,
    "otp":otptextfield.currentOtp
    ]
    executePOST(view: self.view, path: Constants.LIVEURL + Constants.OTP_checker, parameter: parameter){ response in
    let status = response["status"].int
    if(status == Constants.SUCCESS_CODE)
    {
     let vc:SplashScreenViewController = self.storyboard?.instantiateViewController(withIdentifier:"SplashScreenViewController") as! SplashScreenViewController
        self.present(vc, animated:false, completion: nil)
    }
    else
    {
    self.showToast(message:response["errors"].string ?? "")
    }
    }
    
    }
    
    
    
    @IBAction func resendthecodeaction(_ sender: Any)
    {
        let id:String = (someDict["id"] as? String)!
        let parameter:[String:Any] = [
            "userid":id
        ]
        
        executePOST(view: self.view, path: Constants.LIVEURL + Constants.resend_OTP, parameter: parameter){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                 self.showToast(message:"Resend the code successfully")
            }
            else
            {
              //  self.showToast(message:response["errors"].string ?? "")
            }
        }

      
        
    }
    

    
    

}
