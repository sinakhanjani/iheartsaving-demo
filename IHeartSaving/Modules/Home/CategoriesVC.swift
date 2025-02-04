//
//  CategoriesVC.swift
//  IHeartSaving
//
//  Created by Mo on 9/16/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit

final class CategoriesVC:MainVC
{
    var vcConfig:(title:String,id:Int)!
    private var items = Array<Category>()
    var isFavouriteVendor = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if isFavouriteVendor {
            self.getVendorsFavourite()
            self.title = "Favorite Vendors"
        }
        else {
            self.title = vcConfig.title
            self.fetchData(id: vcConfig.id)
        }
    }
    
    @IBOutlet weak var tableView:TableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(SimpleCell.self)
        }
    }
}


extension CategoriesVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SimpleCell.reuseIdentifier) as! SimpleCell
        cell.lblTitle.text = self.items[indexPath.row].title ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = ListVC.instantiate()
        vc.categoryId = self.items[indexPath.row].id
        vc.categoryName = (self.title ?? "") + " > " + self.items[indexPath.row].title
        vc.isFavouriteVendor = isFavouriteVendor
        self.show(vc, sender: nil)
    }
}

extension CategoriesVC
{
    private func fetchData(id:Int)
    {
        guard let  categories = DAL.getCategories(withParent: id) else {return}
        let categoriesWithAll =  [Category(JSON: ["id":id,"title":"All","parent":id])!] + categories
        self.items = categoriesWithAll
        self.tableView.reloadData()
    }
    
    private func getVendorsFavourite() {
        guard let user = DAL.getUser() else {return}
        self.startLoading()
        Service.shared.getVendorFavourites(userid: user.id) { (result) in
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
                self.tableView.reloadData()
            }
        }
    }
    
}

//MARK: - StoryboardInstantiable
extension CategoriesVC : StoryboardInstantiable
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
