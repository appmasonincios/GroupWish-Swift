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
import TwitterCore
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift
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
    @IBOutlet weak var passwordTextF:SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailTextF:SkyFloatingLabelTextFieldWithIcon!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       self.emailTextF.iconType = .image
       self.emailTextF.iconImage = UIImage.init(named:"email")
        
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
  //  IQKeyboardManager.shared.enableAutoToolbar = false
       
        // Do any additional setup after loading the view.
   }
    
    override func viewDidAppear(_ animated: Bool) {
        //IQKeyboardManager.shared.enableAutoToolbar(false)
     //   IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //IQKeyboardManager.shared.enableAutoToolbar(true)
        //  IQKeyboardManager.shared.enableAutoToolbar = true
        
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
            executePOSTLogin(view: self.view, path: Constants.LIVEURL + Constants.Login_check, parameter: parameter){ response in
                let status = response["status"].int
                if(status == Constants.SUCCESS_CODE)
                {
                 let s = SignIn.init(json:response["data"].dictionaryObject!)
                    savesharedprefrence(key:Constants.USERNAME, value:s?.username ?? "")
                    savesharedprefrence(key:Constants.ID, value:s?.id ?? "")
                    savesharedprefrence(key:Constants.LOCATION, value:s?.location ?? "")
                    savesharedprefrence(key:Constants.FRIENDS, value:s?.friends ?? "")
                    savesharedprefrence(key:Constants.PROFILE_PIC, value:s?.profile_pic ?? "")
                    savesharedprefrence(key:Constants.TOKEN, value:response["token"].string ?? "")
                    
                 let token  =  getSharedPrefrance(key:Constants.TOKEN)
                    
                    print(token)
                    
                     savesharedprefrence(key:"loginsession", value:"true")
                    
                    AppConstants.appDelegete.changeRootViewController(selectedIndexOfTabBar:0)
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
    @IBAction func forgotbuttonaction(_ sender: Any)
    {
       // var email:String = self.emailTextF.text!
        
        
        if !(emailTextF.text == "")
        {
            var forgotCredentials: [String : Any] = [:]
            
            forgotCredentials["email"] = emailTextF.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
            if Reachability.isConnectedToNetwork()
            {
                let email:String = (self.emailTextF?.text)!
                let parameter:[String:Any] = [
                    "email": email
                ]
                executePOST(view: self.view, path: Constants.LIVEURL + Constants.forgot_pass, parameter: parameter){ response in
                    let status = response["status"].intValue
                    if(status == Constants.SUCCESS_CODE)
                    {
                         self.showToast(message:response["description"].string ?? "")
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
        else
        {
            self.showToast(message:"Please enter email")
        }
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
      twittermethod()
    }

    
    func twittermethod()
    {
        if Reachability.isConnectedToNetwork()
        {
            TWTRTwitter.sharedInstance().logIn { session, error in
                if (session != nil)
                {
                    print("signed in as \(session!.userName)");
                    let client = TWTRAPIClient.withCurrentUser()
                    let request = client.urlRequest(withMethod: "GET",
                                                    urlString: "https://api.twitter.com/1.1/account/verify_credentials.json",
                                                    parameters: ["include_email": "true", "skip_status": "true"],
                                                    error: nil)
                    client.sendTwitterRequest(request)
                    { response, data, connectionError in
                      
                        if (error != nil)
                        {
                            DispatchQueue.main.async(execute: {
                                self.showToast(message:(error?.localizedDescription)!)
                            })
                        }
                        else
                        {
                            DispatchQueue.main.async(execute: {
                                
                                self.hud?.show(animated:true)
                                
                            })
                        }
                        var twiterData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                        if let twiterData = twiterData {
                            print("reasponse in as  \(String(describing: twiterData))")
                        }
                 
                     
                        var twiterDeatils = [String:Any]()
                       twiterDeatils["social_id"] = session?.userID
                       twiterDeatils["username"] = session?.userName
                       twiterDeatils["provider"] = "Twitter"
                        twiterDeatils["device"] = "Ios"
                        twiterDeatils["email"] = twiterData??["email"]
                        //twiterDeatils["profile_pic"] = twiterData!["profile_image_url_https"]
                        twiterDeatils["device_token"] = getSharedPrefrance(key:"devicetoken")
                      
                       
                        
                        self.postthegoogledetails(parameters:twiterDeatils)
                   }
                }
                else
                {
                    print("error: \(error!.localizedDescription)");
                }
            }
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
                if error == nil
                {
                    var userData = result as? [String : Any]
                    
                    let picture:[String:Any] = userData?["picture"] as! [String : Any]
                    let data:[String:Any] = picture["data"] as! [String : Any]
            
                   print(data)
                    
                    if let url = data["url"] as? URL
                    {
                        let string = "\(url)"
                    savesharedprefrence(key:Constants.PROFILE_PIC, value:string)
                        
                    }
                    else
                    {
                        
                    }
        
                    
                    
                    var parameter: [String: Any] = [:]
                    
                    parameter["social_id"] = userData?["id"]
                    parameter["provider"] = "Facebook"
                    parameter["username"] = userData?["name"]
                    parameter["email"] = userData?["email"]
                    parameter["device_token"] = UserDefaults.standard.value(forKey: "devicetoken")
                    parameter["device"] = "Ios"
        
                    let urlString = Constants.LIVEURL + Constants.social_login


                    executePOST(view: self.view, path:urlString, parameter: parameter){ response in
                        let status = response["status"].int
                        if(status == 200)
                        {
                            print(response)
                            
                            
                            savesharedprefrence(key:Constants.ID, value:response["data"]["id"].string ?? "")
                            savesharedprefrence(key:Constants.USERNAME, value:response["data"]["username"].string ?? "")
                            savesharedprefrence(key:Constants.EMAIL, value:response["data"]["email"].string ?? "")
                            savesharedprefrence(key:Constants.FRIENDS_COUNT, value:response["data"]["friends"].string ?? "")
                            savesharedprefrence(key:Constants.LOCATION, value:"")
                            savesharedprefrence(key:Constants.social_login, value:"1")
                           
                            UIView.beginAnimations("View Flip", context: nil)
                            UIView.setAnimationDuration(0.8)
                            UIView.setAnimationTransition(.curlDown, for:self.view, cache: false)
                            UIView.setAnimationBeginsFromCurrentState(true)
                            UIView.commitAnimations()
                            
                            savesharedprefrence(key:"loginsession", value:"true")
                            AppConstants.appDelegete.changeRootViewController(selectedIndexOfTabBar:0)
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
        
        if let error = error
        {
            print("\(error.localizedDescription)")
        } else
        {
        self.userId      = user?.userID ?? ""
        self.idToken     = user?.authentication.idToken ?? ""
        self.username    = user?.profile.name ?? ""
        self.useremail   = user?.profile.email ?? ""
        self.accessToken = user?.authentication.accessToken ?? ""

        if (GIDSignIn.sharedInstance()?.currentUser.profile.hasImage)!
        {
            self.urlProfileImage = user.profile.imageURL(withDimension:160)
        }
        GIDSignIn.sharedInstance()?.signOut()
            DispatchQueue.main.async(execute: {
                //processer
                self.showprogress("1", for:self)
               self.hud?.hide(animated:true)
            })
        
        
            let url = Constants.WS_GoogleSignIn + accessToken
        print(url)
            executeGET(view: self.view, path:url){ response in
                let status = response["name"]["givenName"].string
                
                print(response)
                if(!(status?.isEmpty)!)
                {
                    let urlprofileimage:String = self.urlProfileImage?.absoluteString ?? ""
                   
                    savesharedprefrence(key:Constants.PROFILE_PIC, value:response["image"]["url"].string!)

                    
                var googleDetails = [String:Any]()
                googleDetails["social_id"] = self.userId
                googleDetails["provider"] = "Google"
                googleDetails["username"] = self.username
                googleDetails["email"] = self.useremail
                googleDetails["profile_pic"] = urlprofileimage
                googleDetails["devicetoken"] = getSharedPrefrance(key:Constants.DEVICETOKEN)
                googleDetails["device"] = "Ios"
                    
                    
                   self.postthegoogledetails(parameters:googleDetails)
             
                }
                else
                {
                    self.showToast(message:response["errors"].string ?? "")
                }
        }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!)
    {
       
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
   
    func postthegoogledetails(parameters:[String:Any])
    {
        let urlString = Constants.LIVEURL + Constants.social_login
        executePOST(view: self.view, path:urlString, parameter: parameters){ response in
            let status = response["status"].int
            if(status == 200)
            {
                savesharedprefrence(key:Constants.ID, value:response["data"]["id"].string ?? "")
                savesharedprefrence(key:Constants.USERNAME, value:response["data"]["username"].string ?? "")
                savesharedprefrence(key:Constants.EMAIL, value:response["data"]["email"].string ?? "")
                savesharedprefrence(key:Constants.FRIENDS_COUNT, value:response["data"]["friends"].string ?? "")
                savesharedprefrence(key:Constants.LOCATION, value:"")
                savesharedprefrence(key:Constants.social_login, value:"1")
                
                UIView.beginAnimations("View Flip", context: nil)
                UIView.setAnimationDuration(0.8)
                UIView.setAnimationTransition(.curlDown, for:self.view, cache: false)
                UIView.setAnimationBeginsFromCurrentState(true)
                UIView.commitAnimations()
                
                savesharedprefrence(key:"loginsession", value:"true")
                AppConstants.appDelegete.changeRootViewController(selectedIndexOfTabBar:0)
            }
            else
            {
                
                self.showToast(message:response["errors"].string ?? "")
            }
            
        }
    }
    
}


