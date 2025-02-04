//
//  Service.swift
//  IHeartSaving
//
//  Created by Mo on 7/21/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import UIKit

struct Service
{
    static let shared = Service()
    
    private let mainUrl = "https://iheartsaving.ca/appapi/"
    
    func login(email:String,password:String,cb: @escaping (Result<User>)->Void)
    {
        let url = self.mainUrl + "Login"
        let params = ["email":email,"password":password]
        Alamofire.request(url, method: .post, parameters: params).responseObject { (response: DataResponse<User>) in
            cb(response.result)
        }
    }
  
    func signup(fname:String,lname:String,phone:String,cityid:Int,tokenid:String,birthdate:String,email:String,sex:Bool,password:String,cb: @escaping (Result<String>)->Void)
    {
        let url = self.mainUrl + "SignUp"
        let params:Parameters = ["fname":fname,"lname":lname,"phone":phone,"cityid":cityid,"tokenid":tokenid,"birthdate":birthdate,"email":email,"sex":sex,"password":password]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
            cb(response.result) //ok||error
        }
    }
    
    func getCities(userId:Int,cb: @escaping (Result<[City]>)->Void)
    {
        let url = self.mainUrl + "getCities"
        let params:Parameters = ["userid":userId]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseArray { (response:DataResponse<[City]>) in
            cb(response.result)
        }
    }
    
    func getCategiries(cb: @escaping (Result<[Category]>)->Void)
    {
        let url = self.mainUrl + "GetCategories"
        Alamofire.request(url, method: .post).responseArray { (response:DataResponse<[Category]>) in
            cb(response.result)
        }
    }
    
    func getUserDetails(userid:Int,cb: @escaping (Result<UserDetailsModel>)->Void)
    {
        let url = self.mainUrl + "UserDetails"
        let params:Parameters = ["userid":userid]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response:DataResponse<UserDetailsModel>) in
            
            cb(response.result)
        }
    }
    
    func couponDetails(id:Int,userid:Int,cb: @escaping (Result<Coupon>)->Void)
    {
        let url = self.mainUrl + "GetCouponDetails"
        let params:Parameters = ["id":id,"userid":userid]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response:DataResponse<Coupon>) in
            cb(response.result)
        }
    }
    
      func getCouponsList(params:GetCouponRequestModel,cb: @escaping (Result<[Coupon]>)->Void)
      {
          let url = self.mainUrl + "GetCoupons"
          Alamofire.request(url, method: .post, parameters: params.toJSON(), encoding: JSONEncoding.default).responseArray { (response:DataResponse<[Coupon]>) in
              cb(response.result)
          }
      }
      
    
      func getVendorCouponsList(params:GetCouponRequestModel,cb: @escaping (Result<[Coupon]>)->Void)
      {
          let url = self.mainUrl + "GetVendorsCoupons"
          print("paramsJson :: \(params.toJSON())")
          Alamofire.request(url, method: .post, parameters: params.toJSON(), encoding: JSONEncoding.default).responseArray { (response:DataResponse<[Coupon]>) in
              cb(response.result)
          }
      }
      
    func setFavorite(userid:Int,couponId:Int,state:Bool,cb: @escaping (Result<String>)->Void)
    {
        let url = self.mainUrl + "SetFavorite"
        let params:Parameters = ["userid":userid,"couponid":couponId,"state":state]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
            cb(response.result)
        }
    }
    func setFavoriteVendor(userid:Int,couponId:Int,state:Bool,cb: @escaping (Result<String>)->Void)
    {
        let url = self.mainUrl + "SetVendorFave"
        let params:Parameters = ["userid":userid,"couponid":couponId,"state":state]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
            print("PRES:1 \(response) params: \(params)")
            cb(response.result)
        }
    }
    func getFavourites(userid: Int, page: Int = 0, perpage: Int = 10, cb: @escaping (Result<[Coupon]>) -> Void ) {
        let url = self.mainUrl + "GetFavoriteCoupons"
        let params: Parameters = ["userid": userid, "page": page, "perpage": perpage]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseArray { (response) in
            cb(response.result)
        }
    }
    
    func getVendorFavourites(userid: Int, page: Int = 0, perpage: Int = 50, cb: @escaping (Result<[Category]>) -> Void ) {
        let url = self.mainUrl + "GetFavoriteVendors"
        let params: Parameters = ["userid": userid, "page": page, "perpage": perpage]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseArray { (response) in
            cb(response.result)
        }
    }
    
    func search(userid:Int,searchKey:String,page:Int = 0,perpage:Int = 50, cb: @escaping (Result<[Coupon]>) -> Void)
    {
        let url = self.mainUrl + "SearchCoupons"
        let params: Parameters = ["userid": userid, "searchKey": searchKey, "page": page, "perpage": perpage]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseArray { (response) in
            cb(response.result)
        }
    }
    
    func getVersion(cb: @escaping (Result<String>)->Void)
    {
        let url = self.mainUrl + "getiosversion"
        Alamofire.request(url).responseString { (response) in
            cb(response.result)
        }
    }
    
    func uploadAvatar(forImage image: UIImage, cb: @escaping (Result<String>) -> Void) {
        let imageData = image.jpegData(compressionQuality: 0.3)
        let url = self.mainUrl + "UploadAvatar?userid=" + String(DAL.getUser()!.id)
        let params = ["userid": DAL.getUser()!.id]
        if let _imageData = imageData {
            Alamofire.upload(multipartFormData: { (multiform) in
                multiform.append(_imageData, withName: "avatar", fileName: "avatar.jpeg", mimeType: "image/jpeg")
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload
                        .responseString(completionHandler: { (res) in
                            cb(res.result)
                        })
                case .failure(let error):break
                }
            })
        }
    }
    func editProfile(userId: Int, fname: String, lname: String, phone: String, cityId: Int, birthDate: String, email: String, sex: Bool, password: String, tokenId: String, cb: @escaping (Result<String>) -> Void) {
        let url = self.mainUrl + "EditUser"
        let params: Parameters = [
            "userid": userId,
            "fname": fname,
            "lname": lname,
            "phone": phone,
            "cityid": cityId,
            "birthdate": birthDate,
            "email": email,
            "sex": sex,
            "password": password,
            "tokenid": tokenId
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
            cb(response.result)
        }
    }
    
    func reedemCode(userid:Int,couponId:Int,amount:Int,cb: @escaping (Result<String>)->Void)
    {
        let url = self.mainUrl + "RedeemCode"
        let params:Parameters = ["userid":userid,"couponid":couponId,"amount":amount]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
            cb(response.result)
        }
    }
}
