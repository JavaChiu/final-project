//
//  MediaManager.swift
//  Recipe
//
//  Created by Jerry Lo on 2/9/18.
//  Copyright © 2018 Jerry Lo. All rights reserved.
//

import Foundation
import UIKit

class MediaManager: NSObject {
    // Static class variable
    static let shared = MediaManager()

    // MARK: Properties
    fileprivate var vc: UIViewController!
    var imageProcessing: ((UIImage?) -> Void)?
    
    private func pickMedia(from source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = source
            vc.present(picker, animated: true, completion: nil)
        }
    }

    func showActionSheet(vc: UIViewController, removePhoto: Bool = false) {
        self.vc = vc
        let actionSheet = UIAlertController(title: "Pick a Photo", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.pickMedia(from: .camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.pickMedia(from: .photoLibrary)
        }))
        if removePhoto {
            actionSheet.addAction(UIAlertAction(title: "Remove Photo", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
                self.imageProcessing?(nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }

}

extension MediaManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageProcessing?(image)
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageProcessing?(image)
        } else {
            return
        }
        vc.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        vc.dismiss(animated: true, completion: nil)
    }
}
