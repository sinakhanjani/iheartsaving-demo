//
//  Text.swift
//  IHeartSaving
//
//  Created by Mo on 7/23/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation


struct Text
{
    
}

extension Text
{
    enum Title:String
    {
        case ListVC = "ALL Discounts"
    }
}


extension Text
{
    enum Message:String
    {
        case errorTitle = "ooooops";
        case serviceTitle = "Connection Error!!"
        case needUpdate = "Update App"
        
        case inputFailed = "check your inputs";
        case checkEmailAndPassword = "check input email and password";
        case savingToDbFailed = "error in saving data to db";
        case updateAvailable = "A new update is available for I Heart Saving. We suggest to update your app."
    }
}
