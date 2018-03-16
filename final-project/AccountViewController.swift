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
import FirebaseAuth

class AccountViewController: UIViewController {
    // MARK: Properties
    var dict : [String : AnyObject]!
    
    // MARK: Outlets
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addressField: UITextField!

    // MARK: Actions
    @IBAction func editPressed(_ sender: Any) {
    }
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        let center = CGPoint.init(x: self.view.frame.width/2, y: self.view.frame.height-100)
        loginButton.center = center
        loginButton.delegate = self
        view.addSubview(loginButton)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (FBSDKAccessToken.current()) != nil{
            // do stuff
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
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                return
            }
            SharedNetworking.shared.firebaseID = user!.uid
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("logged out")
        SharedNetworking.shared.firebaseID = nil
    }
}
