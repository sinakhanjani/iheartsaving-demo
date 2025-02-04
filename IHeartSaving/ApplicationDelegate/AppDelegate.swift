//
//  AppDelegate.swift
//  IHeartSaving
//
//  Created by Mo on 7/21/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FacebookCore
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        setupKeyboard()
        GIDSignIn.sharedInstance().clientID = "881077332510-udhmhruu64lb7d2e84otpc0u0ieuqla1.apps.googleusercontent.com"
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
}

extension AppDelegate
{
    func setupKeyboard()
    {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 30
    }
}
