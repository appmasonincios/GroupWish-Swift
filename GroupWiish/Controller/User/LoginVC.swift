//
//  LoginViewController.swift
//  GroupWiish
//
//  Created by apple on 05/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import TransitionButton
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit

class LoginVC: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate
{
   
    
     var userId:String = ""
     var idToken:String = ""
     var username:String = ""
     var useremail:String = ""
     var accessToken:String = ""
     var urlProfileImage: URL?
    var hud: MBProgressHUD?
    var fbManager:FBSDKLoginManager?
    @IBOutlet weak var forgotpasswordbutton: UIButton!
    @IBOutlet weak var signinbutton: UIButton!
    @IBOutlet weak var passwordTextF: UITextField!
    @IBOutlet weak var emailTextF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signupbuttonaction(_ sender: Any)
    {
       
        let vc:SignUpVC = storyboard?.instantiateViewController(withIdentifier:"SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated:false)
    }
    
    
    func signinapi()
    {
        if Reachability.isConnectedToNetwork() {
           
            let email:String = (self.emailTextF?.text)!
            let password:String = (self.passwordTextF?.text)!
            let parameter:[String:Any] = [
                "email": email,
                "password":password
            ]
            executePOST(view: self.view, path: Constants.LIVEURL + Constants.Login_check, parameter: parameter){ response in
                let status = response["description"].string
                if(status == "success")
                {
                    print(response)
                    //  AppConstants.appDelegete.changeRootViewController(selectedIndexOfTabBar:0)
                }
                else
                {

                    self.showToast(message:response["errors"].string ?? "")
                }
                
            }
        }
        else
        {
            self.showToast(message:"No Internet Connection")
        }
       
        
    }
    @IBAction func forgotbuttonaction(_ sender: Any) {
    }
    
    
    @IBAction func signinbuttonaction(_ sender: Any)
    {
        
        if !(self.emailTextF?.text?.isValidEmail())!
        {
            self.showToast(message:"Please Enter Vaild Mail")
        }
        else if (self.passwordTextF.text?.isEmpty)!
        {
            self.showToast(message:"Please Enter Vaild Password")
        }
        else
        {
            signinapi()
        }
    }
    
    

    @IBAction func twitterbuttonaction(_ sender: Any)
    {
        if Reachability.isConnectedToNetwork()
        {
            
            TWTRTwitter.sharedInstance().logIn(completion: { session, error in
                
                if error != nil {
                   // Shared.sharedInstance().showToast(withMessage: error?.localizedDescription, onVc: self, type: "2")
                } else {
                    
                    let client = TWTRAPIClient()
                    
                    let request: URLRequest? = client.urlRequest(withMethod: "GET", urlString: "https://api.twitter.com/1.1/account/verify_credentials.json", parameters: [
                        "include_email": "true",
                        "skip_status": "true"
                        ], error: nil)
                    
                    client.sendTwitterRequest(request!) { response, data, connectionError in
                        if error != nil {
                            DispatchQueue.main.async(execute: {
                                 self.showToast(message:error?.localizedDescription ?? "")
                            })
                        } else {
                            
                            DispatchQueue.main.async(execute: {
                              //  Shared.sharedInstance().showprogress("1", forViewController: self)
                            })
                            var twiterData: [AnyHashable : Any]? = nil
                            if let data = data {
                                twiterData = try! JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable : Any]
                            }
                            if let twiterData = twiterData {
                                print("reasponse in as  \(twiterData)")
                            }
                            
                            var twiterDeatils: [AnyHashable : Any] = [:]
                            
                            twiterDeatils["social_id"] = twiterData?["id_str"]
                            twiterDeatils["provider"] = "Twitter"
                            twiterDeatils["username"] = twiterData?["name"]
                            twiterDeatils["email"] = twiterData?["email"]
                            twiterDeatils["profile_pic"] = twiterData?["profile_image_url_https"]
                            twiterDeatils["device_token"] = UserDefaults.standard.value(forKey: "devicetoken")
                            twiterDeatils["device"] = "Ios"
                            if let data = data {
                                twiterData = try! JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable : Any]
                            }
                            if let twiterData = twiterData {
                                print("reasponse in as  \(twiterData)")
                            }
                            UserDefaults.standard.set(twiterData?["profile_image_url_https"], forKey: "profile_pic")
                            UserDefaults.standard.synchronize()
                            
                            
                            
                            
                            
                            
                           // Shared.sharedInstance().webAPIRequestHelper(self, vc: self, postdata: twiterDeatils, tag: Tag_SocialLogin, httpMethod: "POST")
                        }
                        
                    }
                }
            })

 
        }
        else
        {
             self.showToast(message:"Please check internet connection")
        }
    }
    
    @IBAction func instgrambuttonaction(_ sender: Any)
    {
       
        if Reachability.isConnectedToNetwork()
        {
            let instaController = storyboard?.instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController
            if let instaController = instaController {
                
                present(instaController, animated: true)
            }
        }
        else
        {
            self.showToast(message:"Please check internet connection")
        }
    }
    
    @IBAction func facebookbuttonaction(_ sender: Any)
    {
        if Reachability.isConnectedToNetwork()
        {
            self.view.endEditing(true)
            
            self.fbManager?.logOut()
            
            self.fbManager = FBSDKLoginManager()
            
            self.fbManager?.logIn(withReadPermissions: ["public_profile", "email"], from:self, handler: { result, error in
                
                if (error != nil)
                {
                    
                    DispatchQueue.main.async(execute: {
                        self.showToast(message:"Oops! Something Went Wrong")
                                    })
                }
                else if (result?.isCancelled)!
                {
                    
                    //do nothing
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                     self.showprogress("1", for:self)
                                            })
                }
            })
       fetchUserinfo()
        }
        else
        {
             self.showToast(message:"No Internet Connection")

        }
       
 
    }
    
    func fetchUserinfo()
    {
        if (FBSDKAccessToken.current() != nil)
        {
        
            FBSDKGraphRequest.init(graphPath:"me", parameters:["fields": "id,name,email,picture.width(100).height(100)"]).start(completionHandler: { connection, result, error in
                if error == nil {
                    var userData = result as? [AnyHashable : Any]
                    
                    UserDefaults.standard.set(((userData?["picture"] as? [AnyHashable : Any])?["data"] as? [AnyHashable : Any])?["url"], forKey: "profile_pic")
                    UserDefaults.standard.synchronize()
                    
                    var parameter: [String: Any] = [:]
                    
                    parameter["social_id"] = userData?["id"]
                    parameter["provider"] = "Facebook"
                    parameter["username"] = userData?["name"]
                    parameter["email"] = userData?["email"]
                    parameter["device_token"] = UserDefaults.standard.value(forKey: "devicetoken")
                    parameter["device"] = "Ios"
        
                    var urlString = Constants.WS_ImageUrl + Constants.WS_GoogleSignIn
                    var postString = ""
                    
                   
                    if let object = parameter["social_id"], let object1 = parameter["provider"], let object2 = parameter["username"], let object3 = parameter["email"], let object4 = parameter["device_token"], let object5 = parameter["device"] {
                        postString = "social_id = \(object)&provider = \(object1)&username = \(object2)&email = \(object3)&device_token=\(object4)&device=\(object5)"
                    }


                    executePOST(view: self.view, path:urlString + postString, parameter: parameter){ response in
                        let status = response["description"].string
                        if(status == "success")
                        {
                            print(response)
                           
                            
                        }
                        else
                        {
                            
                            self.showToast(message:response["errors"].string ?? "")
                        }
                        
                    }
                    
                  //  Shared.sharedInstance().webAPIRequestHelper(self, vc: self, postdata: facebookDetails, tag: Tag_SocialLogin, httpMethod: "POST")
                } else {
                    DispatchQueue.main.async(execute: {
                        self.showToast(message:"Oops! Something Went Wrong")
                    })
                }
            })
        } else {
            
            self.fbManager?.logOut()
            self.showToast(message:"Oops! Something Went Wrong")
        }
 
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        userId      = user.userID
        idToken     = user.authentication.idToken
        username    = user.profile.name
        useremail   = user.profile.email
        accessToken = user.authentication.accessToken

        if (GIDSignIn.sharedInstance()?.currentUser.profile.hasImage)!
        {
            self.urlProfileImage = user.profile.imageURL(withDimension:160)
        }
        GIDSignIn.sharedInstance()?.signOut()
            DispatchQueue.main.async(execute: {
                //processer
                self.showprogress("1", for:self)
            })
            let url = Constants.WS_GoogleSignIn + accessToken
            executeGET(view: self.view, path:url){ response in
                let status = response["description"].string
                if(status == "success")
                {
                    print(response)
                }
                else
                {
                    self.showToast(message:response["errors"].string ?? "")
                }
        }
    }
    
    @IBAction func googleloginbuttonaction(_ sender: Any)
    {
        if Reachability.isConnectedToNetwork()
        {
            GIDSignIn.sharedInstance()?.uiDelegate = self
            GIDSignIn.sharedInstance()?.delegate = self
            GIDSignIn.sharedInstance()?.clientID = Constants.GOOGLE_CLIENT_ID
            GIDSignIn.sharedInstance()?.scopes = ["https://www.googleapis.com/auth/plus.login","https://www.googleapis.com/auth/plus.me","profile","https://www.googleapis.com/auth/userinfo.profile"]
            GIDSignIn.sharedInstance()?.signIn()
        }
        else
        {
            self.showToast(message:"No Internet Connection")
        }
    }
    
    func showprogress(_ str: String?, for vc: UIViewController?)
    {
        if str == "1"
        {
            self.hud = MBProgressHUD.showAdded(to:(vc?.view)!, animated:true)
            self.hud?.mode = MBProgressHUDMode.indeterminate
            self.hud?.label.text = "Loading.."
            self.hud?.removeFromSuperViewOnHide = true
            self.hud?.bezelView.color = UIColor.white
            self.hud?.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
            self.hud?.backgroundView.color = UIColor.init(white:0, alpha:0.1)
        }
        else
        {
            self.hud?.hide(animated:true)
        }
    }
   
}
