//
//  Label.swift
//  IHeartSaving
//
//  Created by Mo on 7/22/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit

class Label:UILabel
{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure()
    {
        self.textColor = Theme.Color.darktext
        self.minimumScaleFactor = 0.4
        self.allowsDefaultTighteningForTruncation = true
    }
}

class LabelBold:Label
{
    override func configure() {
        super.configure()
        self.font = Theme.Font.bold(size: self.font.pointSize)
    }
}

class LabelRegular:Label
{
    override func configure() {
        super.configure()
        self.font = Theme.Font.regular(size: self.font.pointSize)
    }
}

class LabelLight:Label
{
    override func configure() {
        super.configure()
        self.font = Theme.Font.light(size: self.font.pointSize)
    }
}
