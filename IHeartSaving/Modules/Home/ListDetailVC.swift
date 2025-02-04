//
//  ListDetailVC.swift
//  IHeartSaving
//
//  Created by Mo on 9/19/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit
import MapKit

final class ListDetailVC:MainVC
{
    var couponid: Int!
    private var coupon:Coupon!
    let locationManager = CLLocationManager()
    @IBOutlet private weak var tableView:TableView!
    {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.bounces = false
            tableView.register(ListDetailBannerCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        self.getCouponDetail(forCoupon: couponid)
    }
}

extension ListDetailVC
{
    private func getCouponDetail(forCoupon coupon:Int)
    {
        guard let user = DAL.getUser() else {return}
        self.startLoading()
        Service.shared.couponDetails(id:couponid , userid: user.id) { (result) in
            self.stopLoading()
            switch result
            {
            case .failure(let error):
                self.showMessage(title: Text.Message.errorTitle.rawValue, message: error.localizedDescription)
            case.success(let value):
                if value.id == -1 { return }
//                let id = self.coupon.id
                self.coupon = value
//                self.coupon.id = id
                self.tableView.reloadData()
            }
        }
    }
}

extension ListDetailVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListDetailBannerCell.reuseIdentifier) as! ListDetailBannerCell
        if coupon != nil {
            self.coupon.id = couponid
            cell.configureCell(withCoupon: self.coupon, delegate: self)
        }
        return cell
    }
}

extension ListDetailVC:ListDetailBannerCellDelegate
{
    func vendorNameClick() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VendorDetailModal") as! VendorDetailModal
        vc.vendorName = coupon.vendor
        vc.messageString = coupon.vendorDesc
        present(vc, animated: false, completion: nil)
    }
    
    func showWeb() {
        UIApplication.shared.open(URL(string: "https://\(coupon.website ?? "www.google.com")")!, options: [:], completionHandler: nil)
    }
    
    func callMobile() {
        UIApplication.shared.open(URL(string: "tel://+1\(coupon.phone ?? "0")")!)
    }
    
    func showMap() {
        let mapController = MapController()
        mapController.title = "Map"
        mapController.couponTitle = coupon.vendor
        if let lat = coupon.latitude, let log = coupon.longitude {
            mapController.des = CLLocationCoordinate2D(latitude: lat, longitude: log)
        }
        self.navigationController?.pushViewController(mapController, animated: true)
    }
    
    func redeemCode() {
        let alert = UIAlertController(title: "Are you sure about redeeming this coupon?", message: nil, preferredStyle: .alert)
        let yes = UIAlertAction(title: "yes", style: .default) { (_) in
            Service.shared.reedemCode(userid: DAL.getUser()!.id, couponId: self.coupon.id ?? 0, amount: (self.coupon.giftorpercent ?? false) ? 0 : Int(alert.textFields?.first?.text ?? "0") ?? 0) { (response) in
                (self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ListDetailBannerCell).isRedeemed = true
                let modal = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "RedeemedVC") as! RedeemedVC
                self.present(modal, animated: false, completion: nil)
                NotificationCenter.default.post(name: .didReceiveMoney, object: nil, userInfo: nil)
//                self.showMessage(title: "The coupon became redeemed. Thanks for supporting!", message: "")
            }
        }
        let no = UIAlertAction(title: "no", style: .cancel, handler: nil)
        alert.addAction(no)
        alert.addAction(yes)
        if !(coupon.giftorpercent ?? false) {
            alert.addTextField { (textField) in
                textField.keyboardType = .numberPad
            }
            alert.message = "What was your total purchase? (excluding taxes and gratuities)"
        }
        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
extension Notification.Name {
    static let didReceiveMoney = Notification.Name("didReceiveMoney")
}
//MARK: - StoryboardInstantiable
extension ListDetailVC : StoryboardInstantiable
{
    static var storyboardName: String
    {
        return StoryBoardName.Main.rawValue
    }
    
    static var storyboardIdentifier: String?
    {
        return String(describing: self)
    }
    
}
class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var loc: CLLocationCoordinate2D?
    let mapView = MKMapView()
    lazy var buttonItem = MKUserTrackingBarButtonItem(mapView: mapView)
    var des: CLLocationCoordinate2D?
    var couponTitle: String?
    override func viewDidLoad() {
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        navigationItem.rightBarButtonItem = buttonItem
        mapView.frame = self.view.frame
        self.view.addSubview(mapView)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        guard let lat = des?.latitude,let lon = des?.longitude else {return}
        loc = mapView.userLocation.coordinate
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let annotations = MKPointAnnotation()
        annotations.title = couponTitle
        annotations.coordinate = coordinate
        mapView.setCenter(coordinate, animated: true)
        mapView.addAnnotation(annotations)
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    func map() {
        guard let lat = des?.latitude,let lon = des?.longitude else {return}
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        if let l = loc {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: l, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile
            let directions = MKDirections(request: request)
            
            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                for route in unwrappedResponse.routes {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        }

    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        loc = userLocation.coordinate
        map()
    }
}
