//
//  AccountViewController.swift
//  final-project
//
//  Created by Andrew Chiu on 28/02/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        loginButton.delegate = self
        
        view.addSubview(loginButton)
    }    

}

extension AccountViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("logged in")
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("logged out")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(nextViewController, animated:true, completion:nil)
    }
}
