//
//  Getworkout.swift
//  OneBeat
//
//  Created by osvinuser on 20/12/18.
//  Copyright © 2018 osvinuser. All rights reserved.
//


import Foundation
import Gloss
class MyVideosModelClass:JSONDecodable
{
    var datetime:String? = ""
    var message: String? = ""
    var thank_card: Int?
    var friend_pic: String? = ""
    var greeting_id:String? = ""
    var title:String? = ""
    var friend_id:String? = ""
    var thumb_image:String? = ""
    var id:String? = ""
    var video_name:String? = ""
    var friend_name:String? = ""
    var is_personal_video:String? = ""
    var final_video:String? = ""
    

    required init?(json: JSON)
    {
        self.datetime = "datetime" <~~ json
        self.message = "message" <~~ json
        self.thank_card = "thank_card" <~~ json
        self.friend_pic = "friend_pic" <~~ json
        self.greeting_id = "greeting_id" <~~ json
        self.title = "title" <~~ json
        self.friend_id = "friend_id" <~~ json
        self.thumb_image = "thumb_image" <~~ json
        self.id = "id" <~~ json
        self.video_name = "video_name" <~~ json
        self.friend_name = "friend_name" <~~ json
        self.is_personal_video = "is_personal_video" <~~ json
        self.final_video = "final_video" <~~ json
    }


    

}
