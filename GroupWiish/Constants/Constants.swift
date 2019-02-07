//
//  Constants.swift
//  GetBlushh
//
//  Created by Arvind Mehta on 13/12/17.
//  Copyright © 2017 Arvind Mehta. All rights reserved.
//

import Foundation
struct Constants
{
    
    struct appTitle {
        
        static let alertTitle        = "GroupWiish"
    }

    
//    /******************************************************
//     Import Rgb colour helper macros
//     ******************************************************/
//
//    #define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]
//    #define RGBA(r, g, b, a) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:a]
//
//    /******************************************************
//     Import All device type info by macros
//     ******************************************************/

    let IS_IPAD = UI_USER_INTERFACE_IDIOM() == .pad
    let IS_IPHONE = UI_USER_INTERFACE_IDIOM() == .phone
    let IS_RETINA = UIScreen.main.scale >= 2.0
    
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//    let SCREEN_MAX_LENGTH = max(self.SCREEN_WIDTH,self.SCREEN_HEIGHT)
//    let SCREEN_MIN_LENGTH = min(self.SCREEN_WIDTH, self.SCREEN_HEIGHT)
//    let IS_IPHONE_4_OR_LESS = self.IS_IPHONE && self.SCREEN_MAX_LENGTH < 568.0
//    let IS_IPHONE_5 = IS_IPHONE && SCREEN_MAX_LENGTH == 568.0
//    let IS_IPHONE_6 = IS_IPHONE && SCREEN_MAX_LENGTH == 667.0
//    let IS_IPHONE_6P = IS_IPHONE && SCREEN_MAX_LENGTH == 736.0
//    let IS_IPHONE_X = IS_IPHONE && SCREEN_MAX_LENGTH == 812.0
//
//
    /******************************************************
     For Keychain access info by macros
     ******************************************************/

    //  Converted to Swift 4 by Swiftify v4.2.24871 - https://objectivec2swift.com/
    /******************************************************
     For Keychain access info by macros
     ******************************************************/
    
    // Used for saving to NSUserDefaults that a PIN has been set and as the unique identifier for the Keychain
    let PIN_SAVED = "hasSavedPIN"
    
    // Used for saving the users name to NSUserDefaults
    let USERNAME = "username"
    
    // Used to specify the Application used in Keychain accessing
    let APP_NAME = Bundle.main.infoDictionary?["CFBundleIdentifier"]
    
    // Used to help secure the PIN
    // Ideally, this is randomly generated, but to avoid unneccessary complexity and overhead of storing the Salt seperately we will standardize on this key.
    // !!KEEP IT A SECRET!!
    let SALT_HASH = "FvTivqTqZXsgLLx1v3P8TGRyVHaSOB1pvfm02wvGadj7RLHV8GrfxaZ84oGA8RsKdNRpxdAojXYg9iAj"
    
    // Typedefs just to make it a little easier to read in code
    enum AlertTypes : Int {
        case kAlertTypePIN = 0
        case kAlertTypeSetup
    }
    
    enum TextFieldTypes : Int {
        case kTextFieldPIN = 1
        case kTextFieldName
        case kTextFieldPassword
    }
    let PREMIUM_APP_STORE_LINK = "https://itunes.apple.com/SG/app/id1211730146?mt=8"
    



//    /******************************************************
//     Server info by macros
//     ******************************************************/
     let SPLASH_SCREEN_TIME = 3.0
     let SUCCESS_CODE = 200
     let FAILURE_CODE = 400
    
    
    static let WS_VideoUrl:String = "https://groupwish.s3.amazonaws.com/videos"
    static let WS_ImageUrl:String = "https://groupwish.s3.amazonaws.com/images"
    static let TWITTER_URL_SCHEME:String = "twitterkit-CSHOeFBPqqeLrYE5T3jn5f00s"
    static let GOOGLE_URL_SCHEME:String  =  "com.googleusercontent.apps.451408287284-ajadruvp2om1mjg74vdlb9asuqpdu3sm"
    static let GOOGLE_CLIENT_ID:String  = "451408287284-ajadruvp2om1mjg74vdlb9asuqpdu3sm.apps.googleusercontent.com"
    static let WS_GoogleSignIn:String  =  "https://www.googleapis.com/plus/v1/people/me?access_token="
    static let FACEBOOK_URL_SCHEME:String = "fb2213655088675019"
    static let Instagram_Url:String  = "https://api.instagram.com/oauth/access_token"
    static let INSTAGRAM_AUTHURL:String = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_APIURl:String  = "https://api.instagram.com/v1/users/"
    static let INSTAGRAM_CLIENT_ID:String  = "5fcf10686e284a9b977039df4747731d"
    static let INSTAGRAM_CLIENTSERCRET:String = "6249634296f14d0aa22ca4a58ec3c238"
    static let INSTAGRAM_REDIRECT_URI:String = "http://ec2-54-173-211-167.compute-1.amazonaws.com"
    static let INSTAGRAM_ACCESS_TOKEN:String = "access_token"
    static let INSTAGRAM_SCOPE:String = "likes+comments+relationships+follower_list+public_content"
    static let TWITTER_CONSUMER_KEY:String  = "CSHOeFBPqqeLrYE5T3jn5f00s"
    static let TWITTER_CONSUMER_SECRET:String = "ffl5VVH0Ea5BFozu209WLr6XnAyyRrtnnJw0uD9mP1gXzni87d"
     static let LIVEURL:String = "http://ec2-18-217-201-202.us-east-2.compute.amazonaws.com/Group/"
     static let REGISTER:String = "Register/insert_user"
     static let Login_check:String = "Login_check"
     static let social_login:String = "Login_check/social_login"
     static let user_details:String = "user_details"
     static let update_user:String = "Register/update_user"
     static let forgot_pass:String = "User/forgot_pass"
     static let insert_greeting:String = "Greetings/insert_greeting"
     static let greeting_list:String = "Greetings/greeting_list"
     static let greeting_videos:String = "Videos/greeting_videos"
     static let delete_greeting:String = "Greetings/delete_greeting"
     static let send_video_host:String = "Videos/send_video_host"
     static let send_video_user:String = "Videos/send_video_user"
     static let merge_videos:String = "Videos/merge_videos"
     static let friends_greetings_list:String = "Greetings/friends_greetings_list"
     static let send_final_video:String = "Videos/send_final_video"
     static let delete_videos:String = "Videos/delete_videos"
     static let user_contacts:String = "Contacts/user_contacts"
     static let delete_contact:String = "Contacts/delete_contact"
     static let get_friend_requests:String = "Contacts/get_friend_requests"
     static let request_response:String = "Contacts/request_response"
     static let videos_history:String = "Videos/videos_history"
     static let search_contacts:String = "Contacts/search_contacts"
     static let get_final_videos:String = "Videos/get_final_videos"
     static let reset_password:String = "User/reset_password"
     static let show_all_cards:String = "Thanku_card/show_all_cards"
     static let get_host_card:String = "Thanku_card/get_host_card"
     static let insert_cards_data:String = "Thanku_card/insert_cards_data"
     static let delete_card:String = "Thanku_card/delete_card"
     static let OTP_checker:String = "Register/OTP_checker"
     static let resend_OTP:String = "Register/resend_OTP"
     static let get_greeting_details:String = "Greetings/get_greeting_details"
     static let get_friend_cards:String = "Thanku_card/get_friend_cards"
     static let user_profile_pic:String = "User/user_profile_pic"
     static let get_friend_requests_counts:String = "Contacts/get_friend_requests_counts"
     static let RESEND_OTP:String = "Register/resend_OTP"
    
}



