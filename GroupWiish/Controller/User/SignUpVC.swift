//
//  SignUpViewController.swift
//  GroupWiish
//
//  Created by apple on 05/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var conformpasswordtF: UITextField!
    @IBOutlet weak var mobilenumberTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sugnupbuttonaction(_ sender: Any) {
      
        if Reachability.isConnectedToNetwork()
        {
            
                     if (self.nameTF.text?.isEmpty)!
                        {
                            showToast(message:"Please Enter Name")
                        }
                     else if (self.emailTF.text?.isEmpty)! || !(self.emailTF?.text?.isValidEmail())!
                        {
                            showToast(message:"Please Enter Email Address")
                        }
                        else if (self.passwordTF.text?.isEmpty)! || ((self.passwordTF.text?.count)!) > 6 && ((self.passwordTF.text?.count)!) < 10
                        {
                            showToast(message:"Please Enter Vaild Password")
                        }
                     else if (self.conformpasswordtF.text?.isEmpty)!  || ((self.conformpasswordtF.text?.count)!) > 6 && ((self.conformpasswordtF.text?.count)!) < 10
                     {
                         showToast(message:"Please Enter confirm Password")
                     }
                     else if self.conformpasswordtF.text !=  self.passwordTF.text
                     {
                        showToast(message:"confirm password and new password field must be same")
                     }
                     else if !self.validate(value:(self.mobilenumberTF?.text)!)
                     {
                        showToast(message:"please enter valid mobile number")
                     }
                     else if self.locationTF.text?.isEmpty == true
                     {
                        showToast(message:"please enter valid mobile number")
                     }
                        else
                        {
                            signupapi()
                        }
        }
        else
        {
            self.showToast(message:"No Internet Connection")

        }

    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    

  func  signupapi()
    {
    
     // username, email, password, mobile , profile_pic
        let name:String = (self.nameTF?.text)!
        let email:String = (self.emailTF?.text)!
        let password:String = (self.passwordTF?.text)!
        let mobile:String = (self.mobilenumberTF?.text)!
        
        
        let parameter:[String:Any] = [
            "email": email,
            "password":password,
            "username":name,
            "mobile":mobile
        ]
        executePOST(view: self.view, path: Constants.LIVEURL + Constants.REGISTER, parameter: parameter){ response in
            let status = response["description"].string
            if(status == "success")
            {
                
         AppConstants.appDelegete.changeRootViewController(selectedIndexOfTabBar:0)
                print(response)
            }
            else
            {
                self.showToast(message:response["errors"].string ?? "")
            }
        }

    }
    
    
    
    

}
