//
//  LoginVC.swift
//  IHeartSaving
//
//  Created by Mo on 7/21/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit

enum VersionControl
{
    case ok
    case update
    case forceUpdate
}

final class LoginVC:MainVC
{
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    
    @IBAction func btnLogin_pressed()
    {
        guard self.validate(email: txtEmail.text, password: txtPassword.text) else
        {
            self.showMessage(title: Text.Message.errorTitle.rawValue,
                             message: Text.Message.inputFailed.rawValue)
            return
        }
        self.isLoading(true)
        self.login(email: txtEmail.text!, password: txtPassword.text!) { (response) in
            self.isLoading(false)
            guard let user = response.result else
            {
                self.showMessage(title: Text.Message.errorTitle.rawValue, message: response.message ?? "");return;
            }
            var us = user
            us.password = self.txtPassword.text!
            guard DAL.saveUser(us) else
            {
                self.showMessage(title: Text.Message.errorTitle.rawValue, message: Text.Message.savingToDbFailed.rawValue)
                return
            }
            self.logedIn()
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        SignInModal.create(presented: self) {[weak self] info  in
            let registerVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterMobileVC") as! RegisterMobileVC
            registerVC.info = info
            self?.navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
}


//MARK: - Functionality
extension LoginVC
{
    private func validate(email:String?,password:String?) -> Bool
    {
        guard let email = email,email.isValidEmail else {return false}
        guard let password = password,password.count > 2 else {return false}
        return true
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
    
    private func logedIn()
    {
        let storyboard = UIStoryboard(name: StoryBoardName.Main.rawValue, bundle: nil)
        storyboard.instantiateInitialViewController()!.presentRootVC()
    }
    
    private func isLoading(_ loading:Bool)
    {
        loading ? self.btnLogin.lock() : self.btnLogin.unlock()
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
}

//MARK: - LifeCycle
extension LoginVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.getVersion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}


extension LoginVC
{
    
}
