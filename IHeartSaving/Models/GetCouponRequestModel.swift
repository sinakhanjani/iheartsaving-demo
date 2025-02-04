//
//  GetCouponRequestModel.swift
//  IHeartSaving
//
//  Created by Mo on 9/1/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetCouponRequestModel:Mappable
{
    var category:Int?
    var userid:Int?
    var page:Int?
    var perpage:Int?
    var cityId:Int?
    var vendorid:Int?
    
    init(vendorId:Int,userId : Int,page:Int,perPage:Int = 27) {
        self.vendorid = vendorId
        self.page = page
        self.userid = userId
        self.perpage = perPage
    }
    init(category:Int,userId:Int,page:Int,perPage:Int = 27,cityId:Int)
    {
        self.category = category
        self.userid = userId
        self.page = page
        self.perpage = perPage
        self.cityId = cityId
    }
    
    mutating func mapping(map: Map)
    {
        category <- map["category"]
        userid <- map["userid"]
        page <- map["page"]
        perpage <- map["perpage"]
        cityId <- map["cityid"]
        vendorid <- map["vendorid"]
    }
    
    init?(map: Map)
    {}
}
