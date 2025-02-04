//
//  MainTableViewCell.swift
//  CryptoCurrency
//
//  Created by Mo on 7/14/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit

class MainTableViewCell:UITableViewCell
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure()
    {
        self.backgroundColor = Theme.Color.clear
        self.contentView.backgroundColor = Theme.Color.clear
        self.selectionStyle = .none
    }
}
