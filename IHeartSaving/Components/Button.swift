//
//  Button.swift
//  IHeartSaving
//
//  Created by Mo on 7/21/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit

class Button:UIButton
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure()
    {
        self.titleLabel?.font = Theme.Font.bold(size: 16)
        self.titleLabel?.textColor = Theme.Color.tint
        self.tintColor = Theme.Color.buttonBackground
    }
}
@IBDesignable
class ShadowButton:UIButton
{
    @IBInspectable
    var shadowOpacity : Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    @IBInspectable
    var shadowColor : UIColor = UIColor.black.withAlphaComponent(0.3) {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    @IBInspectable
    var shadowOffset : CGSize = CGSize(width: 0, height: 1) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable
    var shadowRadius : CGFloat = 3 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure()
    {
        self.titleLabel?.font = Theme.Font.bold(size: 16)
        self.titleLabel?.textColor = Theme.Color.tint
        self.tintColor = Theme.Color.buttonBackground
    }
}


final class CurveButton:Button
{
    override func configure() {
        super.configure()
        self.backgroundColor = Theme.Color.buttonBackground
        self.titleLabel?.textColor = Theme.Color.lightText
        self.tintColor = Theme.Color.lightText
        self.addShadowWithCornner(offset: CGSize(width: 0, height: 1), opacity: 0.4, shadowColor: Theme.Color.shadow, radius: 3, cornerRadius: 4)
    }
}
