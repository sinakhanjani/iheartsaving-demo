//
//  ListVC.swift
//  IHeartSaving
//
//  Created by Mo on 7/23/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit

final class ListVC:MainVC
{
    var categoryId:Int?
    var categoryName:String?
    var isFavouriteVendor = false
    
    
    private var items = [Coupon]()
    {
        didSet {
            guard items.count > 0 else {return}
            self.tableView.reloadData()
        }
    }
    var isFromFavourite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categoryName
   
        
        
        if isFavouriteVendor {
            getVendorsCoupons(withVendorId: categoryId)
        }
        else {
            if !isFromFavourite {
                self.getCoupons(withCategoryId: self.categoryId)
            } else {
                self.getCouponsFAvourite()
            }
        }
    }
    
    @IBOutlet private weak var tableView:TableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(ListCell.self)
        }
    }
}


extension ListVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier) as! ListCell
        cell.configureCell(with: self.items[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = ListDetailVC.instantiate()
        vc.couponid = self.items[indexPath.row].id
        self.show(vc, sender: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 4 / 6
    }
}

extension ListVC
{
    private func getCouponsFAvourite() {
        guard let user = DAL.getUser() else {return}
        self.startLoading()
        Service.shared.getFavourites(userid: user.id) { (result) in
            self.stopLoading()
            switch result
            {
            case .failure(let error):
                self.showMessage(title: Text.Message.errorTitle.rawValue, message: error.localizedDescription)
            case.success(let value):
                if value.first?.id == -1 {
                    self.showAlert(title: "There is no item", message: "", action: {
                        self.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                self.items = value
            }
        }
    }
    private func getCoupons(withCategoryId id:Int?)
    {
        guard let user = DAL.getUser() else {return}
        self.startLoading()
        let params = GetCouponRequestModel(category: id ?? 0, userId: user.id, page: 1, cityId: DAL.getCity())
        Service.shared.getCouponsList(params: params) { (result) in
            self.stopLoading()
            switch result
            {
            case .failure(let error):
                self.showMessage(title: Text.Message.errorTitle.rawValue, message: error.localizedDescription)
            case.success(let value):
                if value.first?.id == -1 && value.count == 1 {
                    self.showAlert(title: "There is no item", message: "", action: {
                        self.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                self.items = value
            }
        }
    }
    
    private func getVendorsCoupons(withVendorId id:Int?)
    {
        guard let user = DAL.getUser() else {return}
        self.startLoading()
        let params = GetCouponRequestModel(vendorId: id ?? 0, userId: user.id, page: 1)
        Service.shared.getVendorCouponsList(params: params) { (result) in
            self.stopLoading()
            switch result
            {
            case .failure(let error):
                self.showMessage(title: Text.Message.errorTitle.rawValue, message: error.localizedDescription)
            case.success(let value):
                if value.first?.id == -1 && value.count == 1 {
                    self.showAlert(title: "There is no item", message: "", action: {
                        self.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                self.items = value
            }
        }
    }
    
}

extension ListVC:ListCellDelegate
{
    func like_pressed(cell: ListCell)
    {
        let indexPath = tableView.indexPath(for: cell)!
        var item = items[indexPath.row]
        Service.shared.setFavorite(userid: DAL.getUser()!.id, couponId: item.id ?? 0, state: (item.favorite ?? false) == false) { (response) in
            item.favorite = (item.favorite ?? false) == false
            self.items[indexPath.row] = item
            UIView.performWithoutAnimation({
                let loc = self.tableView.contentOffset
                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.tableView.contentOffset = loc
            })
        }
    }
}


//MARK: - StoryboardInstantiable
extension ListVC : StoryboardInstantiable
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
