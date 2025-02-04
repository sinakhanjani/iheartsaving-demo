//
//  Segement.swift
//  IHeartSaving
//
//  Created by Mo on 7/21/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit

final class SegementControll:UISegmentedControl
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure()
    {
        self.setTitleTextAttributes([NSAttributedString.Key.font: Theme.Font.regular(size: 15)],
                                                for: .normal)
        self.tintColor = Theme.Color.tint
    }
}
