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

class AccountViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    var dict : [String : AnyObject]!
    var isEditable = false
    let addPhoto = UIImage(named: "add_photo2")
    
    // MARK: Outlets
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func editPressed(_ sender: Any) {
        if !isEditable {
            addPanGesturesToView(userImageView)
            self.userNameField.isUserInteractionEnabled = true
            self.emailField.isUserInteractionEnabled = true
            self.addressField.isUserInteractionEnabled = true
            self.editBarButton.title = "Done"
            self.isEditable = true
        } else {
            if let recognizers = userImageView.gestureRecognizers {
                for recognizer in recognizers {
                    userImageView.removeGestureRecognizer(recognizer)
                }
            }
            self.userNameField.isUserInteractionEnabled = false
            self.emailField.isUserInteractionEnabled = false
            self.addressField.isUserInteractionEnabled = false
            self.editBarButton.title = "Edit"
            self.isEditable = false
        }
    }
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNameField.delegate = self
        self.emailField.delegate = self
        self.addressField.delegate = self
        
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
    
    /// Add tap gestures to a view
    /// - Parameter view: The view to attach the gestures to
    func addPanGesturesToView(_ view: UIView) {
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewPostViewController.addNewMedia(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    /// Show and Hide the navigation bar and adjust size of image view
    /// - Parameter recognizer: The gesture that is recognized
    @objc func addNewMedia(_ recognizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
        MediaManager.shared.showActionSheet(vc: self, removePhoto: !(userImageView.image==addPhoto))
        MediaManager.shared.imageProcessing = {(image) in
            if let image = image {
                self.userImageView.image = image
                self.userImageView.contentMode = .scaleAspectFit
            } else {
                self.userImageView.image = self.addPhoto
                self.userImageView.contentMode = .scaleAspectFit
            }
        }
    }
    
    // MARK: UITextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
