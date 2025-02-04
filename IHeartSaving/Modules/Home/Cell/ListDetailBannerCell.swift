//
//  ListDetailBannerCell.swift
//  IHeartSaving
//
//  Created by Mo on 9/22/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import UIKit
import MapKit
import ImageSlideshow

protocol ListDetailBannerCellDelegate
{
    func redeemCode()
    func showMap()
    func showWeb()
    func callMobile()
    func vendorNameClick()
}

class ListDetailBannerCell: MainTableViewCell,NibLoadable,ReusableView  {

    @IBAction func favourVendorPressed(_ sender: Any) {
        Service.shared.setFavoriteVendor(userid: DAL.getUser()!.id, couponId: coupon.id ?? 0, state: (coupon.vendorFave ?? false) == false) { (response) in
            print("PRES: \(response)")
                  self.coupon.vendorFave = (self.coupon.vendorFave ?? false) == false
                  if self.coupon.vendorFave ?? false {
                      self.favourVendor.setImage(UIImage(named: "cards-heart"), for: .normal)
                  } else {
                      self.favourVendor.setImage(UIImage(named: "heart-outline"), for: .normal)
                  }
              }
    }
    
    @IBOutlet weak var favourVendor: UIButton!
    @IBOutlet weak var redeemBtn: CurveButton!
    @IBOutlet weak var slideShow: ImageSlideshow!
    private var coupon: Coupon!
    @IBAction func reedemBtnPressed(_ sender: Button) {
        delegate.redeemCode()
    }
    private var delegate:ListDetailBannerCellDelegate!
    @IBOutlet private weak var lblTitle:UILabel!
    @IBOutlet private weak var lblVendor:UILabel!
    @IBOutlet private weak var lblDate:UILabel!
    @IBOutlet private weak var lblDescription:UILabel!
    @IBOutlet private weak var lblAddress:UILabel!
    @IBOutlet private weak var lblPhone:UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPhone))
            lblPhone.addGestureRecognizer(tap)
            lblPhone.isUserInteractionEnabled = true
        }
    }
    @IBOutlet private weak var lblSite:UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapWeb))
            lblSite.addGestureRecognizer(tap)
            lblSite.isUserInteractionEnabled = true
        }
    }
    @IBOutlet private weak var mapView:MKMapView!
    @IBOutlet private weak var btnFavorite:UIButton!
    @IBOutlet private weak var vwLike:UIVisualEffectView! {
        didSet {
            vwLike.addCornerRadius(radius: vwLike.frame.width / 2)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        lblVendor.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(vendorNameClicked)))
    }
    @objc func vendorNameClicked () {
        delegate.vendorNameClick()
    }
    var isRedeemed: Bool = false {
        didSet {
            redeemBtn.isEnabled = !isRedeemed
            redeemBtn.setTitle(!isRedeemed ? "Tap to Redeem" : "Redeemed", for: .normal)
            redeemBtn.titleLabel?.textColor = .white
            if !isRedeemed {
                redeemBtn.backgroundColor = Theme.Color.buttonBackground
            } else {
                redeemBtn.backgroundColor = .lightGray
            }
        }
    }
    
    @objc private func didTapPhone() {
        delegate.callMobile()
    }
    @objc private func didTapWeb() {
        delegate.showWeb()
    }
    @IBAction func btnFavouritePressed(_ sender: Any) {
        Service.shared.setFavorite(userid: DAL.getUser()!.id, couponId: coupon.id ?? 0, state: (coupon.favorite ?? false) == false) { (response) in
            if response.value == "ok" {
                self.coupon.favorite = (self.coupon.favorite ?? false) == false
                if self.coupon.favorite ?? false {
                    self.btnFavorite.setImage(UIImage(named: "cards-heart"), for: .normal)
                } else {
                    self.btnFavorite.setImage(UIImage(named: "heart-outline"), for: .normal)
                }
            }
        }
    }
        let server = "https://iheartsaving.ca/Uploads/Coupons/"
    func configureCell(withCoupon coupon:Coupon,delegate:ListDetailBannerCellDelegate)
    {
        setupGallery(images: coupon.image?.components(separatedBy: "^").reversed() ?? [])
        self.coupon = coupon
        self.isRedeemed = coupon.redeemed ?? false
        self.delegate = delegate
        self.lblTitle.text = coupon.title
        self.lblVendor.text = coupon.vendor
        self.lblDate.text = coupon.expDate
        self.lblDescription.text = coupon.description
        self.lblAddress.text = coupon.address
        self.lblPhone.text = coupon.phone
        self.lblSite.text = coupon.website
        self.favourVendor.setImage((coupon.vendorFave ?? false)  ?#imageLiteral(resourceName: "cards-heart.png") : #imageLiteral(resourceName: "heart-outline.png") , for: .normal)
        self.showVendorOnMap(coupon: coupon)
        if coupon.favorite ?? false {
            btnFavorite.setImage(UIImage(named: "cards-heart"), for: .normal)
        } else {
            btnFavorite.setImage(UIImage(named: "heart-outline"), for: .normal)
        }
    }
    private func setupGallery(images: [String]) {
        slideShow.delegate = self
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.white
        pageIndicator.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.6)
        slideShow.pageIndicator = pageIndicator
        slideShow.semanticContentAttribute = .forceLeftToRight
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        slideShow.activityIndicator = DefaultActivityIndicator(style: .whiteLarge, color: UIColor.white)
        slideShow.circular = false
     //   slideShow.pageIndicator = nil
        slideShow.contentScaleMode = .scaleAspectFill
        var imageSources = [KingfisherSource]()
        for image in images.reversed() {
            if let url = URL(string: server + (image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")) {
                imageSources.append(KingfisherSource(url: url))
            }
        }
        slideShow.setImageInputs(imageSources)
      //  slideShow.setCurrentPage(imageSources.count - 1, animated: false)
    }
    @objc func fullscreenMap() {
        delegate.showMap()
    }
}


extension ListDetailBannerCell: ImageSlideshowDelegate
{
    func showVendorOnMap(coupon:Coupon)
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(fullscreenMap))
        self.mapView.addGestureRecognizer(tap)
        guard let lat = coupon.latitude,let lon = coupon.longitude else {return}
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let annotations = MKPointAnnotation()
        annotations.title = coupon.vendor
        annotations.coordinate = coordinate
        self.mapView.setCenter(coordinate, animated: true)
        mapView.addAnnotation(annotations)
    }
}
