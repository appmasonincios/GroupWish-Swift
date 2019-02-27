//
//  Greeting_VideosModelClass.swift
//  GroupWiish
//
//  Created by apple on 22/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import Foundation
import Gloss
class Greeting_VideosModelClass: JSONDecodable
{
    var video_name:String? = ""
    var title:String? = ""
    var friend_name:String? = ""
    var id:String? = ""
    var user_id:String? = ""
    var friend_id:String? = ""
    var message:String? = ""
    var is_personal_video:String? = ""
    var final_video:String? = ""
    var datetime:String? = ""
    var profile_pic:String? = ""
    var thumb_image:String? = ""
    
    
    required init?(json: JSON)
    {
        self.profile_pic = "profile_pic" <~~ json
         self.video_name = "video_name" <~~ json
        self.id = "id" <~~ json
        self.title = "title" <~~ json
        self.thumb_image = "thumb_image" <~~ json
        self.user_id = "user_id" <~~ json
        self.final_video = "final_video" <~~ json
        self.datetime = "datetime" <~~ json
        self.friend_name = "friend_name" <~~ json
        self.is_personal_video = "is_personal_video" <~~ json
        self.friend_id = "friend_id" <~~ json
        self.message = "message" <~~ json
    }


    
    
    
    
    
}
