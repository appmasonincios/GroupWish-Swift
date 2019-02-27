//
//  Get_Friend_RequestsModelClass.swift
//  GroupWiish
//
//  Created by apple on 19/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import Foundation
import Gloss
class Get_Friend_RequestsModelClass:JSONDecodable
{

    
    var username:String? = ""
    var email:String? = ""
    var id:String? = ""
    var profile_pic:String? = ""
    var location:String? = ""
  
    
    required init?(json: JSON)
    {
        self.username = "username" <~~ json
        self.email = "email" <~~ json
        self.id = "id" <~~ json
        self.profile_pic = "profile_pic" <~~ json
        self.location = "location" <~~ json
    }
    
    
    
    
}
