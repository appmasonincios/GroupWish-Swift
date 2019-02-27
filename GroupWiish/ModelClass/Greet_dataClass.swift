//
//  Greet_dataClass.swift
//  GroupWiish
//
//  Created by apple on 17/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import Foundation
import Gloss
class Greet_dataClass: JSONDecodable
{
    var title:String? = ""
    var image:String? = ""
    var datetime:String? = ""
    var user_id:String? = ""
    var duedate:String? = ""
    var recipient_name:String? = ""
    var recipient_id:String? = ""
    var message:String? = ""
    var id:String? = ""
    var created_date:String? = ""
    var is_active:String? = ""
    var final_video:String? = ""
    var recipient_image:String? = ""

    required init?(json: JSON) {
        
        self.title = "title" <~~ json
        self.image = "image" <~~ json
        self.datetime = "datetime" <~~ json
        self.user_id = "user_id" <~~ json
        self.duedate = "duedate" <~~ json
        self.recipient_name = "recipient_name" <~~ json
        self.recipient_id = "recipient_id" <~~ json
        self.message = "message" <~~ json
        self.id = "id" <~~ json
        self.created_date = "created_date" <~~ json
        self.is_active = "is_active" <~~ json
        self.final_video = "final_video" <~~ json
        self.recipient_image = "recipient_image" <~~ json
    }
    
    
    
    
    
    
    
    

}

