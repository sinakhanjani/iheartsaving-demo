//
//  NavigationController.swift
//  IHeartSaving
//
//  Created by Mo on 7/21/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit

class NavigationController:UINavigationController
{
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    static var bar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.topItem?.title = ""
        NavigationController.bar = navigationBar
        NavigationController.setupNavigationBar(for: self.navigationBar)
    }
    
    static func setupNavigationBar(for navigationBar:UINavigationBar)
    {
        navigationBar.tintColor = Theme.Color.background
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = Theme.Color.tint
        navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: Theme.Font.bold(size: 20),
                                              NSAttributedString.Key.foregroundColor:Theme.Color.background]
        
        navigationBar.largeTitleTextAttributes = [  NSAttributedString.Key.foregroundColor: Theme.Color.lightText,
                                                    NSAttributedString.Key.font: Theme.Font.bold(size: 30)]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: Theme.Font.bold(size: 15),
                                                             NSAttributedString.Key.foregroundColor:Theme.Color.tint], for: .normal)
    }
}

