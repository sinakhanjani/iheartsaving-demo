//
//  PaymentViewController.swift
//  IHeartSaving
//
//  Created by Mohammad Fallah on 9/19/1398 AP.
//  Copyright © 1398 EtudeTeam. All rights reserved.
//

import UIKit
import WebKit
        
class PaymentViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webkit: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainUrl = "http://iheartsaving.ca/"
        let url = URL(string: "\(mainUrl)home/pay?id=\(DAL.getUser()!.id ?? 1)")
        if let url = url {
            webkit.load(URLRequest(url: url))
        }
        webkit.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - StoryboardInstantiable
extension PaymentViewController : StoryboardInstantiable
{
    static var storyboardName: String
    {
        return StoryBoardName.Main.rawValue
    }
    
    static var storyboardIdentifier: String?
    {
        return String(describing: self)
    }
    
}
