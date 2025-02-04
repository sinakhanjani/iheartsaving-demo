//
//  ProfileVC.swift
//  IHeartSaving
//
//  Created by Mo on 7/23/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit
import YPImagePicker
import Kingfisher

final class ProfileVC:MainVC
{
    @IBAction func logOut(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Do you want to logout?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            window?.rootViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        }
        let cancel = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func favouriteVendor(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
               vc.isFavouriteVendor = true
               navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openAboutUs(_ sender: Any) {
        //
    }
    @IBAction func openContacts(_ sender: Any) {
        //
    }
    @IBAction func openFAQ(_ sender: Any) {
    }
    @IBAction func openIntro(_ sender: Any) {
        let intro = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "IntroViewController")
        present(intro, animated: true, completion: nil)
    }
    var user: User?
    let server = "https://iheartsaving.ca/Uploads/Avatars/"
    @IBAction func openGallery(_ sender: Any) {
        openGallery()
    }
    @IBAction func openFavourite(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListVC") as! ListVC
        vc.isFromFavourite = true
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func editBtnPressed(_ sender: UIBarButtonItem) {
        navigateToEdit()
    }
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var nameLbl: LabelBold!
    @IBOutlet weak var phoneLbl: LabelRegular!
    @IBOutlet weak var locationLbl: LabelRegular!
    @IBOutlet weak var emailLbl: LabelRegular!
    @IBOutlet weak var savedMoneyLbl: LabelRegular!
    @IBOutlet weak var numberOfCouponsLbl: LabelRegular!
    @IBOutlet weak var imgAvatar:UIImageView! {
        didSet {
            imgAvatar.layer.borderColor = UIColor.white.cgColor
            imgAvatar.layer.borderWidth = 1
            imgAvatar.backgroundColor = UIColor.white
            imgAvatar.addCornerRadius(radius: imgAvatar.frame.width / 2)
            imgAvatar.image = imgAvatar.image?.withRenderingMode(.alwaysTemplate)
            imgAvatar.tintColor = Theme.Color.tint
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if let avatar = DAL.getUser()?.avatar, let url = URL(string: ("https://iheartsaving.ca/Uploads/Avatars/" +  (avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") ?? "")) {
            print("AVARAT : \(avatar) url : \(url)")
            
            imgAvatar.kf.setImage(with: url)
        }
    }
    @objc private func openGallery() {
        var configure = YPImagePickerConfiguration.init()
        configure.screens = [.library, .photo]
        configure.library.mediaType = YPlibraryMediaType.photo
        let gallery = YPImagePicker(configuration: configure)
        gallery.didFinishPicking { [unowned gallery] items, _ in
            if let photo = items.singlePhoto {
//                self.imgAvatar.image = photo.image
                Service.shared.uploadAvatar(forImage: photo.image, cb: { (response) in
                    let user = DAL.getUser()!
                    var newUser = user
                    newUser.avatar = (self.server + (response.value ?? ""))
                    DAL.saveUser(newUser)
                    let result = URL(string: self.server + (response.value ?? ""))!
                    self.imgAvatar.kf.setImage(with: result)
                    
                })
            }
            gallery.dismiss(animated: true, completion: {
                NavigationController.setupNavigationBar(for: NavigationController.bar)
            })
        }
        gallery.modalPresentationStyle = .fullScreen
        present(gallery, animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUser()
        setupView()
    }
    private func getUser() {
        guard let user = DAL.getUser() else { return }
        if user.email == nil || user.password == nil { return }
        Service.shared.login(email: user.email, password: user.password) { (response) in
            guard let user = response.value else
            {
                return
            }
            if let nou = response.value?.NOU {
                self.numberOfCouponsLbl.text = "\(nou)"
            }
            if let aou = response.value?.AOU {
                self.savedMoneyLbl.text = "$\(aou)"
            }
        }
    }
    private func navigateToEdit() {
        let editVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        editVC.isFromEdit = true
        navigationController?.pushViewController(editVC, animated: true)
    }
    private func setupView() {
        if let user = user {
            emailLbl.text = user.email
            phoneLbl.text = user.phone
            nameLbl.text = "\(user.firstName ?? "") \(user.lastName ?? "")"
            locationLbl.text = user.city
         //   savedMoneyLbl.text = "\(user.AOU ?? 0)"
          //  numberOfCouponsLbl.text = "\(user.NOU ?? 0)"
        }
    }
    
}
