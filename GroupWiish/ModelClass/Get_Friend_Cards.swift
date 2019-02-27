//
//  Get_Friend_Cards.swift
//  GroupWiish
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import Foundation
import Gloss
class Get_Friend_Cards: JSONDecodable
{

    var friend_name:String? = ""
    var card_name:String? = ""
    var friend_pic:String? = ""
    var friendid:String? = ""
    var id:String? = ""
    var datetime:String? = ""
    var message:String? = ""
    

    required init?(json: JSON)
    {
        self.friend_name = "friend_name" <~~ json
        self.card_name = "card_name" <~~ json
        self.friend_pic = "friend_pic" <~~ json
        self.friendid = "friendid" <~~ json
        self.id = "id" <~~ json
        self.datetime = "datetime" <~~ json
        self.message = "message" <~~ json
    }
    
    
}
