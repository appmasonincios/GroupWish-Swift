//
//  Friends_dataModelClass.swift
//  GroupWiish
//
//  Created by apple on 17/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import Gloss
class Show_all_cards:JSONDecodable
{
    var datetime:String? = ""
    var id:String? = ""
    var card_name:String? = ""

    required init?(json: JSON)
    {
    self.datetime = "datetime" <~~ json
    self.id = "id" <~~ json
    self.card_name = "card_name" <~~ json
    }
}