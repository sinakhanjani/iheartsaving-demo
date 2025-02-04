//
//  TableView.swift
//  CryptoCurrency
//
//  Created by Mo on 7/14/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit

final class TableView:UITableView
{
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure()
    {
        self.backgroundColor = Theme.Color.clear
        self.separatorStyle = .none
    }
}
