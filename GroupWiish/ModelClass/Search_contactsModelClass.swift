//
//  Search_contactsModelClass.swift
//  GroupWiish
//
//  Created by apple on 19/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import Foundation
import Gloss
class Search_contactsModelClass:JSONDecodable
{

  
    var id:String? = ""
    var is_friend:Int?
    var profile_pic:String? = ""
    var location:String? = ""
    var username:String? = ""
    
    required init?(json: JSON)
    {
        self.username = "username" <~~ json
        self.is_friend = "is_friend" <~~ json
        self.id = "id" <~~ json
        self.profile_pic = "profile_pic" <~~ json
        self.location = "location" <~~ json
       
    }
}
