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
import ViewAnimator
import PopItUp
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
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.emailTextF.iconType = .image
        self.emailTextF.iconImage = UIImage.init(named:"email")
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
  
   }
    
    override func viewDidAppear(_ animated: Bool)
    {
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
    }

    @IBAction func signupbuttonaction(_ sender: Any)
    {
        let vc:SignUpVC = storyboard?.instantiateViewController(withIdentifier:"SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated:false)
    }
    
    
    func signinapi()
    {
         savesharedprefrence(key:Constants.toasttype, value:"start")
        
        if Reachability.isConnectedToNetwork() {
           
            let email:String = (self.emailTextF?.text)!
            let password:String = (self.passwordTextF?.text)!
            let parameter:[String:Any] = [
                "email": email,
                "password":password,
                "device":"Ios",
                "device_token":getSharedPrefrance(key:Constants.DEVICETOKEN)]
            
            let url = Constants.LIVEURL + Constants.Login_check
            executePOSTLogin(view: self.view, path:url, parameter: parameter){ response in
                let status = response["status"].int
                if(status == Constants.SUCCESS_CODE)
                {
                   
                     savesharedprefrence(key:Constants.toasttype, value:"0")
                  let s = SignIn.init(json:response["data"].dictionaryObject!)
                    savesharedprefrence(key:Constants.USERNAME, value:s?.username ?? "")
                    savesharedprefrence(key:Constants.ID, value:s?.id ?? "")
                    savesharedprefrence(key:Constants.LOCATION, value:s?.location ?? "")
                    let friends:Int = s?.friends ?? 0
                    savesharedprefrence(key:Constants.FRIENDS, value:"\(friends)")
                    savesharedprefrence(key:Constants.PROFILE_PIC, value:s?.profile_pic ?? "")
                    savesharedprefrence(key:Constants.TOKEN, value:response["token"].string ?? "")
                     savesharedprefrence(key:"loginsession", value:"true")
                
                    if friends == 0
                    {
                        
                        NotificationCenter.default.post(name: Notification.Name("friendzero"), object: nil)
                        
                         AppConstants.appDelegete.changeRootViewController(selectedIndexOfTabBar:3)
                    }
                    else
                    {
                         AppConstants.appDelegete.changeRootViewController(selectedIndexOfTabBar:0)
                    }
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
        if !(emailTextF.text == "")
        {
            let emailtext:String = self.emailTextF.text?.trimmingCharacters(in:CharacterSet.whitespaces) ?? ""
            let urllString:String = "\(Constants.LIVEURL)\(Constants.forgot_pass)?email=\(emailtext)"
            
            if Reachability.isConnectedToNetwork()
            {
                executeGETForForgotPassword(view: self.view, path:urllString){ response in
                    let status = response["status"].intValue
                    
                    if(status == Constants.SUCCESS_CODE)
                    {
                        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordPopUpVC") as? ForgotPasswordPopUpVC else { return }
                        popupVC.popupDelegate = self
                        self.present(popupVC, animated: true, completion: nil)
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
            self.signinapi()
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
                        twiterDeatils["device_token"] = getSharedPrefrance(key:Constants.DEVICETOKEN)
                      
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
                        //self.showToast(message:"Oops! Something Went Wrong")
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
              self.fetchUserinfo()
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
    
                    if let url = data["url"] as? String
                    {
                        let string = "\(url)"
                    savesharedprefrence(key:Constants.PROFILE_PIC, value:string)
                    }
                    else
                    {
                        
                    }
                    //UserDefaults.standard.value(forKey: "devicetoken")
                    var parameter: [String: Any] = [:]
                    parameter["social_id"] = userData?["id"]
                    parameter["provider"] = "Facebook"
                    parameter["username"] = userData?["name"]
                    parameter["email"] = userData?["email"]
                    parameter["device_token"] = getSharedPrefrance(key:Constants.DEVICETOKEN)
                    parameter["device"] = "Ios"
        
                    let urlString = Constants.LIVEURL + Constants.social_login


                    executePOST(view: self.view, path:urlString, parameter: parameter){ response in
                        let status = response["status"].int
                        if status == Constants.SUCCESS_CODE
                        {
                            savesharedprefrence(key:Constants.ID, value:response["data"]["id"].string ?? "")
                            savesharedprefrence(key:Constants.USERNAME, value:response["data"]["username"].string ?? "")
                            savesharedprefrence(key:Constants.EMAIL, value:response["data"]["email"].string ?? "")
                            savesharedprefrence(key:Constants.FRIENDS_COUNT, value:response["data"]["friends"].string ?? "")
                            savesharedprefrence(key:Constants.LOCATION, value:"")
                            savesharedprefrence(key:Constants.social_login, value:"1")
                            savesharedprefrence(key:Constants.TOKEN, value:response["token"].string ?? "")
                            var profilepic:String = ""
                            if let pic = response["data"]["profile_pic"].string
                            {
                                profilepic = Constants.WS_ImageUrl + "/" + pic
                                savesharedprefrence(key:Constants.PROFILE_PIC, value:profilepic)
                            }
                            UIView.beginAnimations("View Flip", context: nil)
                            UIView.setAnimationDuration(0.8)
                            UIView.setAnimationTransition(.curlDown, for:self.view, cache: false)
                            UIView.setAnimationBeginsFromCurrentState(true)
                            UIView.commitAnimations()
                            savesharedprefrence(key:"loginsession", value:"true")
                            let friends:Int =  Int(response["data"]["friends"].string ?? "0")!
                            if friends == 0
                            {
                                AppConstants.appDelegete.changeRootViewController(selectedIndexOfTabBar:3)
                            }
                            else
                            {
                                AppConstants.appDelegete.changeRootViewController(selectedIndexOfTabBar:0)
                            }
                        }
                        else
                        {
                            
                           // self.showToast(message:response["errors"].string ?? "")
                        }
                        
                    }
                    
                  //  Shared.sharedInstance().webAPIRequestHelper(self, vc: self, postdata: facebookDetails, tag: Tag_SocialLogin, httpMethod: "POST")
                } else
                {
                    DispatchQueue.main.async(execute:
                        {
                       // self.showToast(message:"Oops! Something Went Wrong")
                    })
                }
            })
        } else {
            
            self.fbManager?.logOut()
           // self.showToast(message:"Oops! Something Went Wrong")
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
                   // self.showToast(message:response["errors"].string ?? "")
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
        executePOST(view: self.view, path:urlString, parameter: parameters)
        { response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                savesharedprefrence(key:Constants.ID, value:response["data"]["id"].string ?? "")
                savesharedprefrence(key:Constants.USERNAME, value:response["data"]["username"].string ?? "")
                savesharedprefrence(key:Constants.EMAIL, value:response["data"]["email"].string ?? "")
                savesharedprefrence(key:Constants.FRIENDS_COUNT, value:response["data"]["friends"].string ?? "")
                savesharedprefrence(key:Constants.TOKEN, value:response["token"].string ?? "")
                savesharedprefrence(key:Constants.LOCATION, value:"")
                savesharedprefrence(key:Constants.social_login, value:"1")
                
                var profilepic:String = ""
                if let pic = response["data"]["profile_pic"].string
                {
                profilepic = Constants.WS_ImageUrl + "/" + pic
                     savesharedprefrence(key:Constants.PROFILE_PIC, value:profilepic)
                }
                
               
                UIView.beginAnimations("View Flip", context: nil)
                UIView.setAnimationDuration(0.8)
                UIView.setAnimationTransition(.curlDown, for:self.view, cache: false)
                UIView.setAnimationBeginsFromCurrentState(true)
                UIView.commitAnimations()
                savesharedprefrence(key:"loginsession", value:"true")
                  let friends:Int =  Int(response["data"]["friends"].string ?? "0")!
                if friends == 0
                {
                    AppConstants.appDelegete.changeRootViewController(selectedIndexOfTabBar:3)
                }
                else
                {
                    AppConstants.appDelegete.changeRootViewController(selectedIndexOfTabBar:0)
                }
            }
            else
            {
                
               // self.showToast(message:response["errors"].string ?? "")
            }
            
        }
    }
    
}


extension LoginVC: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}

