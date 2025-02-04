//
//  ExViewController.swift
//  IHeartSaving
//
//  Created by Mo on 9/1/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIViewController
{
    func showMessage(title:String,message:String,actionTitle:String? = nil)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: actionTitle ?? "OK", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title:String,message:String,actionTitle:String? = nil,action: @escaping ()->Void)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: actionTitle ?? "OK", style: UIAlertAction.Style.default, handler: { _ in
            action()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentRootVC()
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.rootViewController = self
    }
    
    func startLoading()
    {
        let activityData = ActivityData(size: nil, message: nil, messageFont: nil, messageSpacing: nil, type: NVActivityIndicatorType.circleStrokeSpin, color: nil, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func stopLoading()
    {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}
