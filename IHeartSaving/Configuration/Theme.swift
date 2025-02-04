//
//  Theme.swift
//  IHeartSaving
//
//  Created by Mo on 7/21/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit


struct Theme
{
    
}

extension Theme
{
    struct Color
    {
        static var tint = UIColor(hexString: "36AFB9")
        static var shadow = UIColor.gray
        static var buttonBackground = UIColor(hexString: "BB3264")
        static var lightText = UIColor.white
        static var darktext = UIColor.darkGray
        static var background = UIColor(hexString: "EEF8FF")
        static var clear = UIColor.clear
    }
}

extension Theme
{
    struct Font
    {
        static func bold(size:CGFloat) -> UIFont
        {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        
        static func regular(size:CGFloat) -> UIFont
        {
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        
        static func light(size:CGFloat) -> UIFont
        {
            return UIFont.systemFont(ofSize: size, weight: .light)
        }
    }
}
