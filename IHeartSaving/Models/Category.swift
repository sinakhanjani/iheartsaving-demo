//
//  Category.swift
//  IHeartSaving
//
//  Created by Mo on 9/1/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import ObjectMapper

struct Category:Mappable
{
    private(set) var id:Int!
    private(set) var title:String!
    private(set) var parent:Int?
    
    mutating func mapping(map: Map)
    {
        id <- map["id"]
        title <- map["title"]
        parent <- map["parent"]
    }
    
    init?(map: Map) {}
}
