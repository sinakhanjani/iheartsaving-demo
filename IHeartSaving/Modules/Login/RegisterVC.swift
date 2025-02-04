//
//  RegisterVC.swift
//  IHeartSaving
//
//  Created by Mo on 7/21/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit

final class RegisterVC:MainVC
{
    var isFromEdit = false
    private var birthDatePicker:UIDatePicker!
    @IBOutlet weak var txtFirstName:UITextField!
    @IBOutlet weak var txtLastName:UITextField!
    @IBOutlet weak var segmentGender:UISegmentedControl!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var txtRePassword:UITextField!
    @IBOutlet weak var txtPhoneNumber:UITextField!
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet private weak var txtBirthDay:TextField! {
        didSet {
            self.birthDatePicker = UIDatePicker()
            self.birthDatePicker.datePickerMode = .date
            self.birthDatePicker.addTarget(self, action: #selector(RegisterVC.handleDatePicker(sender:)), for: .valueChanged)
            txtBirthDay.inputView = birthDatePicker
        }
    }
    
    @IBAction private func btnRegister_pressed()
    {
        if txtRePassword.text != txtPassword.text {
            showMessage(title: "Error", message: "Passwords do not match")
            return
        }
        guard self.validate(email: txtEmail.text, password: txtPassword.text) else
        {
            self.showMessage(title: Text.Message.errorTitle.rawValue,
                             message: Text.Message.inputFailed.rawValue)
            return
        }
        if isFromEdit {
            editProfile()
            return
        }
        if let first = txtFirstName.text, let last = txtLastName.text, let birth = txtBirthDay.text, let phone = txtPhoneNumber.text, let email = txtEmail.text, let password = txtRePassword.text {
            Service.shared.signup(fname: first, lname: last, phone: phone, cityid: DAL.getCity(), tokenid: UIDevice.current.identifierForVendor!.uuidString, birthdate: birth, email: email, sex: segmentGender.selectedSegmentIndex == 0, password: password) { (result) in
                if let id = Int(result.value ?? "") {
                    self.login(email: email, password: password) { (response) in
                        guard let user = response.result else
                        {
                            self.showMessage(title: Text.Message.errorTitle.rawValue, message: response.message ?? "");return;
                        }
                        var us = user
                        us.id = Int(result.value ?? "1")
                        us.password = password
                        guard DAL.saveUser(us) else
                        {
                            self.showMessage(title: Text.Message.errorTitle.rawValue, message: Text.Message.savingToDbFailed.rawValue)
                            return
                        }
                        self.logedIn()
                    }
                } else {
                    self.showMessage(title: Text.Message.errorTitle.rawValue, message: result.value ?? "")
                }

            }
        }
    }
    private func editProfile() {
        if let first = txtFirstName.text, let last = txtLastName.text, let birth = txtBirthDay.text, let phone = txtPhoneNumber.text, let email = txtEmail.text, let password = txtRePassword.text {
            if let user = DAL.getUser() {
                Service.shared.editProfile(userId: user.id, fname: first, lname: last, phone: phone, cityId: DAL.getCity(), birthDate: birth, email: email, sex: segmentGender.selectedSegmentIndex == 0, password: password, tokenId: UIDevice.current.identifierForVendor!.uuidString) { (result) in
                    self.login(email: email, password: password) { (response) in
                        guard let user = response.result else
                        {
                            self.showMessage(title: Text.Message.errorTitle.rawValue, message: response.message ?? "");return;
                        }
                        var us = user
                        us.id = DAL.getUser()!.id
                        us.password = password
                        guard DAL.saveUser(us) else
                        {
                            self.showMessage(title: Text.Message.errorTitle.rawValue, message: Text.Message.savingToDbFailed.rawValue)
                            return
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtPhoneNumber.text = DAL.getMobile() ?? ""
        if isFromEdit {
            setupView()
        } else {
            btnRegister.setTitle("Register", for: .normal)
            selectCity()
        }
    }
    func selectCity()
    {
        let vc = LocationVC.instantiate()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    private func logedIn()
    {
        let vc = PaymentViewController.instantiate()
        self.present(vc, animated: false, completion: nil)
//        let storyboard = UIStoryboard(name: StoryBoardName.Main.rawValue, bundle: nil)
//        storyboard.instantiateInitialViewController()!.presentRootVC()
    }
    private func login(email:String,password:String,cb: @escaping ((result:User?,message:String?))->Void)
    {
        Service.shared.login(email: email, password: password) { (result) in
            switch result
            {
            case .failure(let error):
                cb((result: nil, message:error.localizedDescription))
            case .success(let value):
                guard let id = value.id,id != -1 else
                {
                    cb((result: nil, message: Text.Message.checkEmailAndPassword.rawValue));return;
                }
                cb((result: value, message:nil))
            }
            
        }
    }
    private func validate(email:String?,password:String?) -> Bool
    {
        guard let email = email,email.isValidEmail else {return false}
        guard let password = password,password.count > 2 else {return false}
        return true
    }
    private func setupView() {
        title = "Edit Profile"
        btnRegister.setTitle("Edit", for: .normal)
        if let user = DAL.getUser() {
            txtFirstName.text = user.firstName
            txtLastName.text = user.lastName
            segmentGender.selectedSegmentIndex = user.sex == true ? 0 : 1
            txtEmail.text = user.email
            txtPassword.text = user.password
            txtRePassword.text = user.password
            txtPhoneNumber.text = user.phone
            txtBirthDay.text = user.birthdate
        }
    }
}

extension RegisterVC
{
    @objc func handleDatePicker(sender:UIDatePicker) {
        let dateFormmater:DateFormatter = DateFormatter()
        dateFormmater.dateFormat = "yyyy-M-dd"
        txtBirthDay.text = dateFormmater.string(from: sender.date)
    }
    
    private func validate()
    {
        
    }
}

//MARK: - StoryboardInstantiable
extension RegisterVC : StoryboardInstantiable
{
    static var storyboardName: String
    {
        return StoryBoardName.Login.rawValue
    }
    
    static var storyboardIdentifier: String?
    {
        return String(describing: self)
    }
    
}
