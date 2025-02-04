//
//  SearchVC.swift
//  IHeartSaving
//
//  Created by erfan on 7/15/1398 AP.
//  Copyright © 1398 EtudeTeam. All rights reserved.
//

import UIKit

class SearchVC: MainVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var items = Array<Coupon>()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListCell.self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier) as? ListCell else { return UITableViewCell() }
        cell.configureCell(with: self.items[indexPath.row], delegate: self)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ListDetailVC.instantiate()
        vc.couponid = self.items[indexPath.row].id
        self.show(vc, sender: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 4 / 6
    }
    
}
extension SearchVC: UISearchBarDelegate, ListCellDelegate, UITableViewDelegate, UITableViewDataSource {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Service.shared.search(userid: DAL.getUser()!.id, searchKey: searchBar.text ?? "") { (result) in
            if result.value?.first?.id == -1 {
                self.items = []
                self.showAlert(title: "There is no item", message: "", action: {
                })
            }
            if result.value?.first?.id == -1 {
            } else {
                self.items = result.value ?? []
            }
            self.tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func like_pressed(cell: ListCell) {
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
