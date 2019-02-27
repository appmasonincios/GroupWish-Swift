//
//  Getworkout.swift
//  OneBeat
//
//  Created by osvinuser on 20/12/18.
//  Copyright © 2018 osvinuser. All rights reserved.
//


import Foundation
import Gloss
class NotificationClass:JSONDecodable
{
   
   
    var id:String? = ""
    var user_id: String? = ""
    var title: String? = ""
    var message: String? = ""
    var image:String? = ""
    var duedate:String? = ""
    var recipient_name:String? = ""
    var recipient_id:String? = ""
    var created_date:String? = ""
    var is_active:String? = ""
    var final_video:String? = ""
    var datetime:String? = ""
    var dueby:String? = ""
    var username:String? = ""
    var profile_pic:String? = ""
    var video_sent:Int?
   
  
    required init?(json: JSON)
    {
      self.id = "id" <~~ json
      self.user_id = "user_id" <~~ json
      self.title = "title" <~~ json
      self.message = "message" <~~ json
      self.image = "image" <~~ json
      self.duedate = "duedate" <~~ json
      self.recipient_name = "recipient_name" <~~ json
      self.recipient_id = "recipient_id" <~~ json
      self.created_date = "created_date" <~~ json
      self.is_active = "is_active" <~~ json
      self.final_video = "final_video" <~~ json
      self.datetime = "datetime" <~~ json
      self.dueby = "dueby" <~~ json
      self.username = "username" <~~ json
      self.profile_pic = "profile_pic" <~~ json
      self.video_sent = "video_sent" <~~ json
    }


    

}
