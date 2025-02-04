//
//  ShadowView.swift
//  IHeartSaving
//
//  Created by Mo on 7/22/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit


final class ShadowView:View
{
    override func configure() {
        super.configure()
        self.addShadow(offset: CGSize.zero, opacity: 1, shadowColor: Theme.Color.shadow, radius: 3)
    }
}

final class CurveView:View
{
    override func configure() {
        super.configure()
        self.addCornerRadius(radius: 5)
        self.clipsToBounds = true
    }
}

final class CurveShadowView:View
{
    override func configure() {
        super.configure()
        self.addShadowWithCornner(offset: CGSize(width: 0, height: 1), opacity: 1, shadowColor: Theme.Color.shadow.withAlphaComponent(0.5), radius: 2, cornerRadius: 5)
    }
}
