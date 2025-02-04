//
//  Coupon.swift
//  IHeartSaving
//
//  Created by Mo on 9/1/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import ObjectMapper

struct Coupon:Mappable
{
    var id:Int?
    private(set) var title:String?
    private(set) var expDate:String?
    private(set) var vendor:String?
    private(set) var image:String?
    var favorite:Bool?
    var redemeed: Bool?
    private(set) var address:String?
    private(set) var redeemed:Bool?
    private(set) var latitude:Double?
    private(set) var longitude:Double?
    private(set) var phone:String?
    private(set) var website:String?
    private(set) var description:String?
    private(set) var giftorpercent:Bool?
    var vendorFave:Bool?
    private(set) var vendorDesc:String?
    
    mutating func mapping(map: Map) {}
    
    init?(map: Map)
    {
        id <- map["id"]
        title <- map["title"]
        expDate <- map["expDate"]
        vendor <- map["vendor"]
        image <- map["image"]
        favorite <- map["favorite"]
        address <- map["address"]
        redeemed <- map["redeemed"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        phone <- map["phone"]
        website <- map["website"]
        description <- map["description"]
        giftorpercent <- map["giftorpercent"]
        vendorFave <- map["vendorFave"]
        vendorDesc <- map["vendorDesc"]
    }
}
