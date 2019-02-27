//
//  Getworkout.swift
//  OneBeat
//
//  Created by osvinuser on 20/12/18.
//  Copyright © 2018 osvinuser. All rights reserved.
//


import Foundation
import Gloss
class MyContactsModelClass:JSONDecodable
{

   
    var email:String? = ""
    var profile_pic:String? = ""
    var location:String? = ""
    var username:String? = ""
    var id:String? = ""
    var checkmark:String? = ""
    
    required init?(json: JSON)
    {
          self.email = "email" <~~ json
          self.profile_pic = "profile_pic" <~~ json
          self.location = "location" <~~ json
          self.username = "username" <~~ json
         self.id = "id" <~~ json
        self.checkmark = "0"
    }


    

}
