//
//  HomeVC.swift
//  IHeartSaving
//
//  Created by Mo on 7/22/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit



final class HomeVC:MainVC
{
    var first = false
    @IBOutlet weak var locationLabel: UILabel!
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        if let user = DAL.getUser() {
            let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            profile.user = user
            navigationController?.pushViewController(profile, animated: true)
        }
    }
    @IBOutlet weak var moneySaved: LabelRegular!
    @IBAction func searchBtnPressed(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImageView(image: UIImage(named: "logo_white")!)
        logo.contentMode = .scaleAspectFit
        navigationItem.titleView = logo
        if !DAL.getShowCase() {
            first = true
            let intro = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "IntroViewController")
            intro.modalPresentationStyle = .fullScreen
            present(intro, animated: true)
        }
        else {
            getUserDetails()
        }
        getVersion()
        self.getCategories()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSavingToDate), name: .didReceiveMoney, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationLabel.text = DAL.getUser()?.city
        setSavingToDateText()
        if first || !DAL.getActive() {
            getUserDetails()
        }
        else {
            if DAL.getCity == nil || DAL.getCity() == 0 {
               self.selectCity()
            }
        }
    }
    @objc func updateSavingToDate () {
        getUserDetails()
    }
    func getUserDetails () {
        
        guard let userid = DAL.getUser()?.id else { return }
        Service.shared.getUserDetails(userid: userid) {[weak self] (result) in
           switch result
           {
           case .failure(let error):
               self?.showMessage(title: Text.Message.serviceTitle.rawValue, message: error.localizedDescription)
           case.success(let value):
            print("VALLEE: \(value)")
            DAL.setAOU(aou: value.AOU ?? 0)
            DAL.setNOU(aou: value.NOU)
            DAL.setActive(active: value.active ?? false)
            self?.setSavingToDateText()
            self?.checkActivationAccount()
           }
       }
    }
    
    private func getVersion()
    {
        self.startLoading()
        Service.shared.getVersion { (result) in
            self.stopLoading()
            switch result
            {
            case.failure(let error):
                self.showMessage(title: Text.Message.errorTitle.rawValue, message: error.localizedDescription)
            case.success(let value):
                guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {return}
                let versionState = self.compareVersion(app: appVersion, server: value)
                switch versionState
                {
                case .ok:
                    break
                case .forceUpdate:
                    self.showAlert(title: Text.Message.needUpdate.rawValue, message: Text.Message.updateAvailable.rawValue, action: {
                        
                    })
                case .update:
                    self.showMessage(title: Text.Message.needUpdate.rawValue, message: Text.Message.updateAvailable.rawValue)
                }
            }
        }
    }
    func compareVersion(app:String,server:String) -> VersionControl
    {
        let appV = app.components(separatedBy: ".")
        let serverV = server.components(separatedBy: ".")
        guard appV.count == 3,serverV.count == 3 else {return .ok}
        if appV[0] < serverV[0] || appV[1] < serverV[1] {return .forceUpdate}
        else if appV[2] < serverV[2] {return .update}
        else {return .ok}
    }

    
    func checkActivationAccount () {
//        if DAL.getActive() {
        if !DAL.getActive() {
            let alert = UIAlertController(title: "", message: "Your Account has been expired", preferredStyle: .alert)
            alert.addAction(UIAlertAction (title: "Renew", style: .default, handler: { (action) in
                
                    let vc = PaymentViewController.instantiate()
                    self.present(vc, animated: false, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action) in
                let storyboard = UIStoryboard(name: StoryBoardName.Login.rawValue, bundle: nil)
                storyboard.instantiateInitialViewController()!.presentRootVC()
            }))
            present(alert, animated: true, completion: nil)
        }
        else {
            if DAL.getCity == nil || DAL.getCity() == 0 {
                self.selectCity()
           }
        }
    }
    func setSavingToDateText () {
        let aou = DAL.getUser()?.AOU ?? 0
        var strAou : String!
        if aou < 10 {
            strAou = String(format:"%.3f",aou)
        }
        else if aou < 100 {
            strAou = String(format:"%.2f",aou)
        }
        else if aou < 1000 {
            strAou = String(format:"%.1f",aou)
        }
        else {
            strAou = String(describing: Int(aou))
        }
        moneySaved.text = "$" + strAou
    }
    
    @IBAction private func didSelectItem(_ sender:HomeItemView)
    {
        let vc = CategoriesVC.instantiate()
        vc.vcConfig = (sender.lblTitle.text!.replacingOccurrences(of: "\n", with: ""),sender.tag)
        self.show(vc, sender: nil)
    }
    
    @IBAction private func didSelectAllCategories()
    {
        let vc = ListVC.instantiate()
        vc.categoryName = "All Discounts"
        self.show(vc, sender: nil)
    }
}


extension HomeVC
{
    private func getCategories()
    {
        self.startLoading()
        Service.shared.getCategiries { (result) in
            self.stopLoading()
            switch result
            {
            case .failure(let error):
                
                self.showMessage(title: Text.Message.serviceTitle.rawValue, message: error.localizedDescription)
            case.success(let value):
                guard value.count > 0 else
                {
                    return
                }
                guard DAL.saveCategories(value) else
                {
                    return
                }
            }
        }
    }
    
    func selectCity()
    {
        if DAL.getCity() == 0 {
            let vc = LocationVC.instantiate()
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
}
