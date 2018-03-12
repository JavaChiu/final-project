//
//  UIViewControllerExtension.swift
//  final-project
//
//  Created by Jerry Lo on 3/11/18.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    // Attribution: https://stackoverflow.com/questions/32281651/how-to-dismiss-keyboard-when-touching-anywhere-outside-uitextfield-in-swift
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
