//
//  Getworkout.swift
//  OneBeat
//
//  Created by osvinuser on 20/12/18.
//  Copyright © 2018 osvinuser. All rights reserved.
//


import Foundation
import Gloss
class MyVideosHistoryModelClass:JSONDecodable
{

   
    var greeting_id:String? = ""
    var video_name:String? = ""
    var id:String? = ""
    var title:String? = ""
    var thumb_image:String? = ""
    var friend_pic:String? = ""
    var user_id:String? = ""
    var final_video:String? = ""
    var thank_card:Int?
    var datetime:String? = ""
    var friend_name:String? = ""
    var is_personal_video:String? = ""
    var friend_id:String? = ""
    var message:String? = ""
    
    
    required init?(json: JSON)
    {
        self.greeting_id = "greeting_id" <~~ json
        self.video_name = "video_name" <~~ json
        self.id = "id" <~~ json
        self.title = "title" <~~ json
        self.thumb_image = "thumb_image" <~~ json
       self.friend_pic = "friend_pic" <~~ json
       self.user_id = "user_id" <~~ json
       self.final_video = "final_video" <~~ json
       self.thank_card = "thank_card" <~~ json
        self.datetime = "datetime" <~~ json
        self.friend_name = "friend_name" <~~ json
       self.is_personal_video = "is_personal_video" <~~ json
        self.friend_id = "friend_id" <~~ json
        self.message = "message" <~~ json
    }


    

}
