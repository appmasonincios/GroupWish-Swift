//
//  Friends_dataModelClass.swift
//  GroupWiish
//
//  Created by apple on 17/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import Gloss
class Friends_dataModelClass:JSONDecodable
{
    var is_video:Int?
    var location:String? = ""
    var username:String? = ""
    var profile_pic:String? = ""
    var id:String? = ""

    
    required init?(json: JSON)
    {
    self.is_video = "is_video" <~~ json
    self.location = "location" <~~ json
    self.id = "id" <~~ json
    self.username = "username" <~~ json
    self.profile_pic = "profile_pic" <~~ json
   
    }
    
    
    
    
}
