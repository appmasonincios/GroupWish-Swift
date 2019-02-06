//
//  DefaultSharedData.swift
//  Hanord
//
//  Created by Arvind Mehta on 24/10/17.
//  Copyright © 2017 Arvind Mehta. All rights reserved.
//

import Foundation

public func savesharedprefrence(key:String,value:String)
{
    let defaults = UserDefaults.standard
    defaults.set(value, forKey:key )
    UserDefaults.standard.synchronize()
}

public func getSharedPrefrance(key:String) -> String
{
    var return_value = ""
    let userPa = UserDefaults.standard.value(forKey: key)
    if let value = userPa{
        return_value = "\(value)"
    }
    return return_value
}

public func logout()
{
     let defaults = UserDefaults.standard
   
    defaults.synchronize()
}




