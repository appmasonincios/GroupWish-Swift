//
//  Getworkout.swift
//  OneBeat
//
//  Created by osvinuser on 20/12/18.
//  Copyright © 2018 osvinuser. All rights reserved.
//


import Foundation
import Gloss
class MyGreetingsModelClass:JSONDecodable
{

    var recipient_name:String? = ""
    var final_video: String? = ""
    var image:String? = ""
    var created_date: String? = ""
    var id:String? = ""
    var dueby:String? = ""
    var recipient_image:String? = ""
    var is_active:String? = ""
    var datetime:String? = ""
    var recipient_id:String? = ""
    var message:String? = ""
    var user_id:String? = ""
    var title:String? = ""
    var duedate :String? = ""
    var videos_cnt:String? = ""
    
    

    required init?(json: JSON)
    {
       self.recipient_name = "recipient_name" <~~ json
       self.final_video = "recipient_name" <~~ json
       self.image = "image" <~~ json
        self.created_date = "created_date" <~~ json
        self.id = "id" <~~ json
        self.dueby = "dueby" <~~ json
        self.recipient_image = "recipient_image" <~~ json
        self.is_active = "is_active" <~~ json
        self.datetime = "datetime" <~~ json
        self.recipient_id = "recipient_id" <~~ json
        self.message = "message" <~~ json
        self.user_id = "user_id" <~~ json
        self.title = "title" <~~ json
        self.duedate = "duedate" <~~ json
        self.videos_cnt = "videos_cnt" <~~ json

    }


    

}
