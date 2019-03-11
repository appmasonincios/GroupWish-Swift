//
//  Getworkout.swift
//  OneBeat
//
//  Created by osvinuser on 20/12/18.
//  Copyright © 2018 osvinuser. All rights reserved.
//


import Foundation
import Gloss
class SignIn:JSONDecodable
{
    var username:String? = ""
    var location: String? = ""
    var activation: String? = ""
    var friends:Int?
    var profile_pic:String? = ""
    var id:String? = ""
    var token:String? = ""
    
    required init?(json: JSON)
    {
      self.username = "username" <~~ json
      self.id = "id" <~~ json
      self.location = "location" <~~ json
      self.activation = "activation" <~~ json
      self.friends = "friends" <~~ json
      self.profile_pic = "profile_pic" <~~ json
      self.token = "token" <~~ json
    }


    

}
