//
//  UserDetailsModel.swift
//  IHeartSaving
//
//  Created by Mohammad Fallah on 9/18/1398 AP.
//  Copyright © 1398 EtudeTeam. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserDetailsModel:Mappable
{
    private(set) var NOU:Float!
    private(set) var AOU:Float!
    private(set) var active:Bool!

    mutating func mapping(map: Map) {}
    
    init?(map: Map)
    {
        NOU <- map["NOU"]
        AOU <- map["AOU"]
        active <- map["active"]
    }

}
