//
//  DAL.swift
//  IHeartSaving
//
//  Created by Mo on 9/1/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import ObjectMapper

struct DAL
{
    private static let db = UserDefaults.standard
    
    private enum KEYS:String
    {
        case user = "USER"
        case categories = "Categories"
        case showCase = "ShowCase"
        case city = "City"
        case AOU = "AOU"
        case NOU = "NOU"
        case ACTIVE = "Active"
    }
    static func setMobile(mobile: String) {
        db.set(mobile, forKey: "Mobile")
    }
    static func getMobile() -> String? {
        return db.string(forKey: "Mobile")
    }
    static func setCity(id: Int)
    {
        db.set(id, forKey: DAL.KEYS.city.rawValue)
    }
    static func getCity() -> Int
    {
        return db.integer(forKey: DAL.KEYS.city.rawValue)
    }
    static func setAOU(aou: Float)
    {
        db.set(aou, forKey: DAL.KEYS.AOU.rawValue)
    }
    static func getAOU() -> Float
    {
        return db.float(forKey: DAL.KEYS.AOU.rawValue)
    }
    static func setNOU(aou: Float)
    {
        db.set(aou, forKey: DAL.KEYS.NOU.rawValue)
    }
    static func getNOU() -> Float
    {
        return db.float(forKey: DAL.KEYS.NOU.rawValue)
    }
    static func setActive(active: Bool)
    {
        db.set(active, forKey: DAL.KEYS.ACTIVE.rawValue)
    }
    static func getActive() -> Bool
    {
        return db.bool(forKey: DAL.KEYS.ACTIVE.rawValue)
    }
    static func setShowCase()
    {
        db.set(true, forKey: DAL.KEYS.showCase.rawValue)
    }
    static func getShowCase() -> Bool
    {
        return db.bool(forKey: DAL.KEYS.showCase.rawValue)
    }
    
    static func saveUser(_ user:User) -> Bool
    {
        guard let strUser = user.toJSONString() else {return false}
        db.set(strUser, forKey: DAL.KEYS.user.rawValue)
        return true
    }
    
    static func getUser() -> User?
    {
        guard let strUser = db.string(forKey: DAL.KEYS.user.rawValue) else {return nil}
        guard let user = Mapper<User>().map(JSONString:strUser) else {return nil}
        return user
    }
    
    static func saveCategories(_ items:[Category]) -> Bool
    {
        guard let strCategories =  items.toJSONString() else {return false}
        db.set(strCategories, forKey: DAL.KEYS.categories.rawValue)
        return true
    }
    
    static func getCategories(withParent parent:Int) -> [Category]?
    {
        guard let strCategory = db.string(forKey: DAL.KEYS.categories.rawValue) else {return nil}
        guard let categories = Mapper<Category>().mapArray(JSONString: strCategory) else {return nil}
        let filtered = categories.filter { ($0.parent ?? 0) == parent}
        return filtered
    }
}
