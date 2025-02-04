//
//  StoryboardInstantiable.swift
//  HamrahBank
//
//  Created by hafiz on 2/27/18.
//  Copyright © 2018 hafiz. All rights reserved.
//

import Foundation
import UIKit

enum StoryBoardName:String
{
    case Main = "Main"
    case Login = "Login"
}



protocol StoryboardInstantiable
{
    static var storyboardName: String { get }
    static var storyboardBundle: Bundle? { get }
    static var storyboardIdentifier: String? { get }
}

extension StoryboardInstantiable {
    
    static var storyboardIdentifier: String? { return nil }
    static var storyboardBundle: Bundle? { return Bundle.main }
    
    static func instantiate() -> Self
    {
        let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
        
        if let storyboardIdentifier = storyboardIdentifier
        {
            return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        }
        else
        {
            return storyboard.instantiateInitialViewController() as! Self
        }
    }
}
