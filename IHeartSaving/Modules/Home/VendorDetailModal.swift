//
//  VendorDetailModal.swift
//  IHeartSaving
//
//  Created by Mohammad Fallah on 9/14/1398 AP.
//  Copyright © 1398 EtudeTeam. All rights reserved.
//

import UIKit

class VendorDetailModal: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var VendorNameLabel: UILabel!
    
    @IBAction func outClicked(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    var messageString : String?
    var vendorName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageLabel.text = messageString
        self.VendorNameLabel.text = vendorName
    }
    


}
