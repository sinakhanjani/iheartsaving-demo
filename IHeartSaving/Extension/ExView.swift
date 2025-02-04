//
//  ExView.swift
//  IHeartSaving
//
//  Created by Mo on 7/21/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

extension UIView
{
    func addShadowWithCornner(offset:CGSize,opacity:Float,shadowColor:UIColor,radius:CGFloat,cornerRadius : CGFloat)
    {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = true
        clipsToBounds = false
    }
    
    func addShadow(offset:CGSize,opacity:Float,shadowColor:UIColor,radius:CGFloat)
    {
        self.layer.masksToBounds = false;
        self.layer.shadowColor = shadowColor.cgColor;
        self.layer.shadowOffset = offset;
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        
    }
    
    func addCornerRadius(radius:CGFloat)
    {
        self.clipsToBounds = true;
        self.layer.cornerRadius = CGFloat(radius);
        
    }
    
    func lock()
    {
        if let _ = viewWithTag(10) {
            //View is already locked
        }
        else {
            let lockView = UIView()
            lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            lockView.tag = 10
            lockView.alpha = 0.0
            addSubview(lockView)
            lockView.autoPinEdgesToSuperviewEdges()
            let activity = UIActivityIndicatorView(style: .white)
            activity.hidesWhenStopped = true
            lockView.addSubview(activity)
            activity.autoCenterInSuperview()
            activity.startAnimating()
            UIView.animate(withDuration: 0.2) {
                lockView.alpha = 1.0
            }
        }
    }
    
    func unlock()
    {
        if let lockView = viewWithTag(10) {
            UIView.animate(withDuration: 0.2, animations: {
                lockView.alpha = 0.0
            }) { finished in
                lockView.removeFromSuperview()
            }
        }
    }
}

extension UIView
{
    var allSubViews : [UIView]
    {
        var array = [self.subviews].flatMap {$0}
        array.forEach { array.append(contentsOf: $0.allSubViews) }
        return array
    }
    
    
    var parentViewController: UIViewController?
    {
        var parentResponder: UIResponder? = self
        while parentResponder != nil
        {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController
            {
                return viewController
            }
        }
        return nil
    }
    
    public class var nibName: String {
        
        let name = "\(self)".components(separatedBy: ".").first ?? ""
        return name
    }
    
    
    public class var nib: UINib? {
        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
    
    public class func fromNib(nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil: nibNameOrNil, type: self)
        //return fromNib(nibNameOrNil, type: self)
    }
    
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        let v :T? = fromNib(nibNameOrNil: nibNameOrNil, type: T.self)
        return v!
    }
    
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = nibName
        }
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews! {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
    
}
