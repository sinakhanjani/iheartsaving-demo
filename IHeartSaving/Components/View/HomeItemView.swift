//
//  HomeItemView.swift
//  IHeartSaving
//
//  Created by Mo on 7/22/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit

final class HomeItemView:UIControl
{
    @IBOutlet weak var lblTitle:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        for view in self.allSubViews
        {
            view.isUserInteractionEnabled = false
        }
        self.addShadowWithCornner(offset: CGSize(width: 0, height: 1), opacity: 0.4, shadowColor: Theme.Color.shadow, radius: 3, cornerRadius: self.frame.height / 4)
    }
    
}
