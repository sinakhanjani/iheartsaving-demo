//
//  RegisterStep1VC.swift
//  IHeartSaving
//
//  Created by Mohammad Fallah on 9/17/1398 AP.
//  Copyright © 1398 EtudeTeam. All rights reserved.
//

import UIKit


class RegisterStep1VC: UIViewController {

    var info : UserInfo?
    private var birthDatePicker:UIDatePicker!
    @IBOutlet weak var txtFirstName:UITextField!
    @IBOutlet weak var txtLastName:UITextField!
    @IBOutlet weak var segmentGender:UISegmentedControl!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet private weak var txtBirthDay:TextField! {
         didSet {
             self.birthDatePicker = UIDatePicker()
             self.birthDatePicker.datePickerMode = .date
             self.birthDatePicker.addTarget(self, action: #selector(RegisterStep1VC.handleDatePicker(sender:)), for: .valueChanged)
             txtBirthDay.inputView = birthDatePicker
         }
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFirstName.text = info?.name
        txtLastName.text = info?.family
        
        
    }
    @objc func handleDatePicker(sender:UIDatePicker) {
       let dateFormmater:DateFormatter = DateFormatter()
       dateFormmater.dateFormat = "yyyy-M-dd"
       txtBirthDay.text = dateFormmater.string(from: sender.date)
    } 

    @IBAction func btnNextPreseed(_ sender: Any) {
        info?.name = txtFirstName.text
        info?.family = txtLastName.text
        info?.birthDay = txtBirthDay.text
        info?.gender = segmentGender.selectedSegmentIndex == 0
        let registerVC = RegisterStep2VC.instantiate()
       registerVC.info = info
       self.navigationController?.pushViewController(registerVC, animated: true)
    }
   

}

//MARK: - StoryboardInstantiable
extension RegisterStep1VC : StoryboardInstantiable
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
