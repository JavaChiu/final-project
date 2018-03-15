//
//  SplashViewController.swift
//  final-project
//
//  Created by Andrew Chiu on 15/03/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    // MARK: - Properties
    var autoDismiss = false
    
    // MARK: - Outlets
    @IBOutlet weak var dismissButton: UIButton!
    
    
    // MARK: - Actions
    @IBAction func tapContinue(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        // If auto-dismissing hide the button and rely on tap to dismiss
        if self.autoDismiss {
            self.dismissButton.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.dismiss(animated: true, completion: {
                    print("done")
                })
            }
        }
    }


}
