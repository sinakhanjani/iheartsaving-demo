//
//  LocationVC.swift
//  IHeartSaving
//
//  Created by Mo on 7/23/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit

protocol LocationVCDelegate {
    func receiveLocation (name : String)
}
final class LocationVC:UIViewController
{
    var delegate : LocationVCDelegate?
    private var cities = [City]()
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet private weak var indicator:UIActivityIndicatorView!
    @IBOutlet private weak var tableView:TableView!
    {
        didSet
        {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(SimpleCell.self)
        }
    }
}

//MARK: - LifeCycle
extension LocationVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
    }

}

//MARK: - Functions
extension LocationVC
{
    private func fetchData()
    {
        self.indicator.startAnimating()
        Service.shared.getCities(userId: DAL.getUser()?.id ?? 0) { (result) in
            self.indicator.stopAnimating()
            switch result
            {
            case .failure(let error):
                self.showMessage(title: Text.Message.serviceTitle.rawValue, message: error.localizedDescription)
            case .success(let value):
                self.cities = value + ["Coming Soon","Barrie","Guelph","Kawarthas","Kitchener","Kingston","London","Northumberland","Oshawa","Waterloo"].map { str in
                    City(title: str, enabled: false)
                }
            }
        }
    }
    
    private func updateUser(withLocation location:City)
    {
        guard var user = DAL.getUser() else {return}
        user.locationId = location.id
        user.city = location.title
        _ = DAL.saveUser(user)
    }
}

//MARK: - TableView Delegate & DataSource
extension LocationVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: SimpleCell.reuseIdentifier) as! SimpleCell
        cell.lblTitle.text = self.cities[indexPath.row].title ?? ""
        cell.lblTitle.textColor = self.cities[indexPath.row].enabled ? UIColor(hexString: "#36AFB9") : UIColor.lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.cities[indexPath.row].enabled {
            self.dismiss(animated: true)
            {
                self.delegate?.receiveLocation(name: self.cities[indexPath.row].title)
                DAL.setCity(id: self.cities[indexPath.row].id)
                self.updateUser(withLocation: self.cities[indexPath.row])
            }
        }
    }
}

//MARK: - StoryboardInstantiable
extension LocationVC : StoryboardInstantiable
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
