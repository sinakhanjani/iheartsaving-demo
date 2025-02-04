//
//  ListCell.swift
//  IHeartSaving
//
//  Created by Mo on 7/23/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import UIKit

protocol ListCellDelegate
{
    func like_pressed(cell:ListCell)
}

class ListCell: MainTableViewCell,NibLoadable,ReusableView {
    @IBOutlet weak var redeemedBox: UIView!
    
    @IBOutlet weak var gradientView: UIView! {
        didSet {
            let layer = CAGradientLayer()
            layer.colors = [UIColor.white.withAlphaComponent(0.5).cgColor,UIColor.white.cgColor]
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint(x: 0.5, y: 0.5)
            layer.frame = gradientView.bounds
            gradientView.layer.insertSublayer(layer, at: 0)
        }
    }
    private var delegate:ListCellDelegate!
    
    @IBOutlet private weak var imgBanner:ImageView!
    @IBOutlet private weak var btnLike:UIButton!
    @IBOutlet private weak var lblTitle:UILabel!
    @IBOutlet private weak var lblExpDate:UILabel!
    @IBOutlet private weak var lblDescription:UILabel!
    @IBOutlet private weak var vwLike:UIVisualEffectView! {
        didSet {
            vwLike.addCornerRadius(radius: vwLike.frame.width / 2)
        }
    }
    
    let server = "https://iheartsaving.ca/Uploads/Coupons/"
    func configureCell(with coupon:Coupon,delegate:ListCellDelegate)
    {
        self.delegate = delegate
        self.lblTitle.text = coupon.vendor
        self.lblExpDate.text = coupon.expDate
        self.lblDescription.text = coupon.title
        self.redeemedBox.isHidden = !(coupon.redeemed ?? false)
        if let url = URL(string: server + (coupon.image?.components(separatedBy: "^").first?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")) {
            imgBanner.kf.setImage(with: url,placeholder: #imageLiteral(resourceName: "placeholder2.jpg"))
        }
        else {
            imgBanner.image = #imageLiteral(resourceName: "placeholder2.jpg")
        }
        if coupon.favorite ?? false {
            btnLike.setImage(UIImage(named: "cards-heart"), for: .normal)
        } else {
            btnLike.setImage(UIImage(named: "heart-outline"), for: .normal)
        }
    }
    
    @IBAction func btnLike_pressed()
    {
        self.delegate.like_pressed(cell: self)
    }
}
