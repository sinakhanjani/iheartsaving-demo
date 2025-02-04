//
//  SplashVC.swift
//  IHeartSaving
//
//  Created by erfan on 7/17/1398 AP.
//  Copyright © 1398 EtudeTeam. All rights reserved.
//

import UIKit
import SwiftyGif


class LogoAnimationView: UIView {
    
    
    let logoGifImageView = UIImageView(gifImage: try! UIImage(gifName: "intro_logo"), loopCount: 1)
    let logoGifImageView1 = UIImageView(gifImage: try! UIImage(gifName: "icons_gif.gif"), loopCount: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.white
        addSubview(logoGifImageView)
        addSubview(logoGifImageView1)
        logoGifImageView.contentMode = .scaleAspectFit
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoGifImageView.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
        logoGifImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        logoGifImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        logoGifImageView1.contentMode = .scaleAspectFit
        logoGifImageView1.translatesAutoresizingMaskIntoConstraints = false
        logoGifImageView1.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        logoGifImageView1.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 100).isActive = true
        logoGifImageView1.topAnchor.constraint(equalTo: logoGifImageView.bottomAnchor, constant: 10).isActive = true
        logoGifImageView1.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoGifImageView1.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        logoAnimationView.logoGifImageView.delegate = self
        view.addSubview(logoAnimationView)
        logoAnimationView.translatesAutoresizingMaskIntoConstraints = false
        logoAnimationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        logoAnimationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        logoAnimationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        logoAnimationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    let logoAnimationView = LogoAnimationView()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }
    
}
extension SplashVC: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
        if DAL.getUser() == nil {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        } else {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()

        }
    }
}
