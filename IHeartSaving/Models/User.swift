//
//  LoginResponse.swift
//  IHeartSaving
//
//  Created by Mo on 8/25/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import ObjectMapper

struct User:Mappable
{
    var id:Int!
    var phone:String!
    var email:String!
    var firstName:String!
    var NOU: Int!
    var AOU: Float!
    var lastName:String!
    var city:String!
    var birthdate: String!
    var sex: Bool!
    var avatar:String!
    var locationId:Int!
    var password: String!
    var tokenid: String!
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map)
    {
        NOU <- map["NOU"]
        AOU <- map["AOU"]
        tokenid <- map["tokenid"]
        birthdate <- map["birthdate"]
        sex <- map["sex"]
        password <- map["password"]
        id <- map["id"]
        phone <- map["phone"]
        email <- map["email"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        city <- map["city"]
        avatar <- map["avatar"]
        locationId <- map["locationId"] //in app,not from server
    }
}
