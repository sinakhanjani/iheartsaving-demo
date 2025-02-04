//
//  City.swift
//  IHeartSaving
//
//  Created by Mo on 9/1/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import ObjectMapper

struct City:Mappable
{
    private(set) var id:Int!
    private(set) var title:String!
    var enabled = true
    
    init(title : String, enabled : Bool) {
        self.title = title
        self.enabled = enabled
    }
    mutating func mapping(map: Map) {}
    
    init?(map: Map)
    {
        id <- map["id"]
        title <- map["title"]
    }

}
