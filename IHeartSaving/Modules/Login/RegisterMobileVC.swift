//
//  RegisterMobileVC.swift
//  IHeartSaving
//
//  Created by Mo on 9/19/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit
import SinchVerification

typealias UserInfo = (name : String?,family : String?,email : String?,birthDay : String?,gender : Bool?)
final class RegisterMobileVC:MainVC
{
    var verification:Verification!
    let appKey = "62906108-ebc7-4acd-8acc-8c869053c7b8"
    var info : UserInfo?
    @IBOutlet private weak var txtPhoneNumber:TextField!
    
    @IBAction func calloutVerification() {
        self.startLoading()
        verification = SMSVerification(appKey,phoneNumber: "+1" + txtPhoneNumber.text!);
        verification.initiate { (result: InitiationResult, error: Error?) -> Void in
            self.stopLoading()
            switch result.success
            {
            case true:
                let mobile = self.txtPhoneNumber.text?.replacingOccurrences(of: "+1", with: "") ?? ""
                DAL.setMobile(mobile: mobile)
                let vc = RegisterVerificationVC.instantiate()
                vc.verification = self.verification
                vc.mobileNumber = mobile
                vc.info = self.info
                self.show(vc, sender: nil)
            case false:
                self.showMessage(title: Text.Message.errorTitle.rawValue, message: error?.localizedDescription ?? "")
            }
        }
    }
}

extension RegisterMobileVC
{
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.txtPhoneNumber.becomeFirstResponder()
    }
}
