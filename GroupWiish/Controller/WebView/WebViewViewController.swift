//
//  WebViewViewController.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import WebKit
class WebViewViewController: UIViewController,UIWebViewDelegate{


    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var typeOfAuthentication = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        var authURL:String? = nil

        if self.typeOfAuthentication == "UNSIGNED"
        {
            
            authURL = "\(Constants.INSTAGRAM_AUTHURL)?client_id=\(Constants.INSTAGRAM_CLIENT_ID)&redirect_uri=\(Constants.INSTAGRAM_REDIRECT_URI)&response_type=token&scope=\(Constants.INSTAGRAM_SCOPE)&DEBUG=True"
        }
        else
        {
            authURL = "\(Constants.INSTAGRAM_AUTHURL)?client_id=\(Constants.INSTAGRAM_CLIENT_ID)&redirect_uri=\(Constants.INSTAGRAM_REDIRECT_URI)&response_type=code&scope=\(Constants.INSTAGRAM_SCOPE)&DEBUG=True"
            
        }
        

        let url:URL = URL(string:authURL!)!
        self.webview.delegate = self
        self.webview.loadRequest(URLRequest(url:url))

    }
    
//  //  #pragma mark - web view delegate methods

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return checkRequest(forCallbackURL: request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activity.startAnimating()
        webview.layer.removeAllAnimations()
        
        webview.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.1, animations: {
            self.webview.alpha = 0.2
        })
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activity.stopAnimating()
        activity.hidesWhenStopped = true
        webView.layer.removeAllAnimations()
        
        webView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.1, animations: {
            webView.alpha = 1.0
        })
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
    
    
    
    // MARK: - auth logic
    func checkRequest(forCallbackURL request: URLRequest?) -> Bool {
        let urlString = request?.url?.absoluteString
        
        if (typeOfAuthentication == "UNSIGNED") {
            // check, if auth was succesfull (check for redirect URL)
            if urlString?.hasPrefix(Constants.INSTAGRAM_REDIRECT_URI) ?? false {
                // extract and handle access token
                //NSRange range = [urlString rangeOfString: @"#access_token="];
                return false
            }
        } else {
            if urlString?.hasPrefix(Constants.INSTAGRAM_REDIRECT_URI) ?? false {
                // extract and handle access token
                let range: NSRange? = (urlString as NSString?)?.range(of: "code=")
                makePostRequest((urlString as NSString?)?.substring(from: Int((range?.location ?? 0) + (range?.length ?? 0))))
                return false
            }
        }
        
        return true
    }
    
    
    func makePostRequest(_ code: String?) {
        var loginCredentials: [String : Any] = [:]
        
        loginCredentials["client_id"] = Constants.INSTAGRAM_CLIENT_ID
        loginCredentials["client_secret"] = Constants.INSTAGRAM_CLIENTSERCRET
        loginCredentials["grant_type"] = "authorization_code"
        loginCredentials["redirect_uri"] = Constants.INSTAGRAM_REDIRECT_URI
        loginCredentials["code"] = code
        
       print(loginCredentials)
        
        //Instagram_Url
        
        executePOST(view: self.view, path:Constants.Instagram_Url, parameter:loginCredentials){ response in
            
            print(response)
            
             let access_token = response["access_token"].string
            
            if (access_token != nil)
            {
                var userData = response["user"].dictionaryObject
            
                savesharedprefrence(key:Constants.PROFILE_PIC, value:userData?["profile_picture"] as! String)
        
                var instaDetails: [String : Any] = [:]
                instaDetails["social_id"] = userData?["id"]
                instaDetails["provider"] = "Instagram"
                instaDetails["username"] = userData?["full_name"]
                instaDetails["email"] = userData?["full_name"]
                
                self.postthegoogledetails(parameters:instaDetails)
                
            }
            else
            {
                
                
            }

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
                
               // self.showToast(message:response["errors"].string ?? "")
            }
            
        }
    }
    
   
    
  
}
