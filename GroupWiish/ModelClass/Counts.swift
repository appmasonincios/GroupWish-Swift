//
//  Friends_dataModelClass.swift
//  GroupWiish
//
//  Created by apple on 17/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import Gloss
class Counts:JSONDecodable
{
    var pastDue:Int?
    var dueToday:Int?
    required init?(json: JSON)
    {
    self.pastDue = "Past Due" <~~ json
    self.dueToday = "Due Today" <~~ json
    }
}
