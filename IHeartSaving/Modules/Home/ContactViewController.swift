//
//  ContactViewController.swift
//  IHeartSaving
//
//  Created by erfan on 7/17/1398 AP.
//  Copyright © 1398 EtudeTeam. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
    
    @IBAction func calltoNumber(_ sender: Any) {
        if let url = URL(string: "tel://+1\(8667641212)") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func openWeb(_ sender: Any) {
        guard let url = URL(string: "https://iheartsaving.ca") else { return }
        UIApplication.shared.open(url)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
