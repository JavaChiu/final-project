//
//  AccountViewController.swift
//  final-project
//
//  Created by Andrew Chiu on 28/02/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//
// Attribution: https://www.simplifiedios.net/facebook-login-swift-3-tutorial/, https://gist.github.com/reterVision/091200424e122ef14c8c

import UIKit
import FacebookLogin
import FBSDKLoginKit

class AccountViewController: UIViewController {
    var dict : [String : AnyObject]!
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        loginButton.delegate = self
        
        view.addSubview(loginButton)
    }    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Attribution: https://stackoverflow.com/questions/11862883/attempt-to-present-uiviewcontroller-on-uiviewcontroller-whose-view-is-not-in-the
        if (FBSDKAccessToken.current()) != nil{
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainTabView") as! UITabBarController
//            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    // Fetch user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
}

extension AccountViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("logged in")
        self.getFBUserData()
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("logged out")
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
//        self.present(nextViewController, animated:true, completion:nil)
    }
}
