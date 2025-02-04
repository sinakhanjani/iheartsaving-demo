//
//  SignInModal.swift
//  IHeartSaving
//
//  Created by Mohammad Fallah on 9/17/1398 AP.
//  Copyright © 1398 EtudeTeam. All rights reserved.
//

import UIKit
import FacebookLogin
import GoogleSignIn
import FacebookCore
import ObjectMapper

class SignInModal: UIViewController, LoginButtonDelegate , GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        completionHandler?((givenName,familyName,email,nil,nil))
        dismiss(animated: false, completion: nil)
    }
    

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var googleSignIn: GIDSignInButton!
    private var completionHandler: ((UserInfo) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let button = FBLoginButton(permissions: [ .publicProfile,.email])
        button.delegate = self
        stackView.addArrangedSubview(button)
        button.heightConstraint?.constant = 45
    

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    @IBAction func signUpEmailTapped(_ sender: Any) {
        self.completionHandler?((nil,nil,nil,nil,nil))
        dismiss(animated: false, completion: nil)
    }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if result?.isCancelled == true {
            showMessage(title: "Facebook Login", message: "Facebook Login has been Cancelled")
        }
        else {
            let r = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get)

                r.start(completionHandler: { (test, result, error) in
                    if(error == nil)
                    {
                        let model = Mapper<FacebookInfo>().map(JSON: result as! Dictionary)
                        var name = model?.name
                        var family = model?.name
                        if (model?.name?.split(separator: " ").count ?? 0) > 1  {
                            name = name?.split(separator: " ").first?.base
                            family = model?.name?.split(separator: " ")[1].base
                        }
                        self.completionHandler?((name,family,model?.email,nil,nil))
                        self.dismiss(animated: false, completion: nil)
                    }
                })
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
      
    }

    static func create(presented: UIViewController,completion: ((UserInfo) -> Void)?) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String.init(describing: self)) as! SignInModal
        vc.completionHandler = completion
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        presented.present(vc, animated: true, completion: nil)
    }
}

struct FacebookInfo : Mappable {

    var email : String?
    var name : String?
    
    init?(map: Map) {
          
    }
      
    mutating func mapping(map: Map) {
        email <- map["email"]
        name <- map["name"]
   }
}
