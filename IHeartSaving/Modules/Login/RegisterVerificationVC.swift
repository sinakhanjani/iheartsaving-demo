//
//  RegisterVerificationVC.swift
//  IHeartSaving
//
//  Created by Mo on 9/19/19.
//  Copyright © 2019 EtudeTeam. All rights reserved.
//

import Foundation
import UIKit
import SinchVerification

final class RegisterVerificationVC:MainVC
{
    var verification:Verification!
    var mobileNumber : String!
    var info : UserInfo?
    
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet private weak var txtPinCode:TextField!
    
    @IBAction func verify()
    {
        self.startLoading()
        verification.verify(txtPinCode.text!, completion: { (success:Bool, error:Error?) -> Void in
                self.stopLoading()
                if (success) {
                    let vc = RegisterStep1VC.instantiate()
                    vc.info = self.info
                    self.show(vc, sender: nil)
                } else {
                    self.showMessage(title: Text.Message.errorTitle.rawValue, message: error?.localizedDescription ?? "")
                }
        });
    }
    
    override func viewDidLoad() {
        mobileNumberLabel.text = mobileNumber
    }
}

extension RegisterVerificationVC
{
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.txtPinCode.becomeFirstResponder()
    }
}

//MARK: - StoryboardInstantiable
extension RegisterVerificationVC : StoryboardInstantiable
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
