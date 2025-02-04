//
//  RegisterStep2VC.swift
//  IHeartSaving
//
//  Created by Mohammad Fallah on 9/17/1398 AP.
//  Copyright © 1398 EtudeTeam. All rights reserved.
//

import UIKit

class RegisterStep2VC: UIViewController {

  var info : UserInfo?
  @IBOutlet weak var txtEmail:UITextField!
  @IBOutlet weak var txtPassword:UITextField!
  @IBOutlet weak var txtRePassword:UITextField!
  @IBOutlet weak var txtPhoneNumber:UITextField!
  @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var locationTF: TextField!
    
  
  @IBAction private func btnRegister_pressed()
  {
    if selectedCity == false {
        showMessage(title: "Error", message: "Select a Location to Continue")
        return
    }
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
   
      if let first = info?.name, let last = info?.family, let birth = info?.birthDay, let phone = txtPhoneNumber.text, let email = txtEmail.text, let password = txtRePassword.text {
          Service.shared.signup(fname: first, lname: last, phone: phone, cityid: DAL.getCity(), tokenid: UIDevice.current.identifierForVendor!.uuidString, birthdate: birth, email: email, sex: info?.gender ?? true, password: password) { (result) in
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

  override func viewDidLoad() {
      super.viewDidLoad()
      self.txtPhoneNumber.text = DAL.getMobile() ?? ""
      txtEmail.text = info?.email
    
      btnRegister.setTitle("Register", for: .normal)
//      selectCity()
      
  }
    var selectedCity = false
    @IBAction func selectCityDidTap(_ sender: Any) {
        selectedCity = true
        selectCity()
    }
    func selectCity()
  {
      let vc = LocationVC.instantiate()
      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .overFullScreen
      vc.delegate = self
      self.present(vc, animated: true, completion: nil)
  }
  private func logedIn()
  {
    let vc = PaymentViewController.instantiate()
    self.present(vc, animated: false, completion: nil)
//      let mainUrl = "http://iheartsaving.ca/"
//      UIApplication.shared.open(URL(string: "\(mainUrl)home/pay?id=\(DAL.getUser()!.id ?? 1)")!, options: [:], completionHandler: nil)
//      let storyboard = UIStoryboard(name: StoryBoardName.Main.rawValue, bundle: nil)
//      storyboard.instantiateInitialViewController()!.presentRootVC()
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

}
extension RegisterStep2VC : LocationVCDelegate {
    func receiveLocation(name: String) {
        self.locationTF.text = name
    }
}

//MARK: - StoryboardInstantiable
extension RegisterStep2VC : StoryboardInstantiable
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
