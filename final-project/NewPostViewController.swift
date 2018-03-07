//
//  NewPostViewController.swift
//  final-project-mock-up
//
//  Created by Andrew Chiu on 18/02/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    // MARK: Outlets and Actions
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var removeImageButton: UIButton!
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addNewMedia() {
        MediaManager.shared.showActionSheet(vc: self)
        MediaManager.shared.imageProcessing = {(image) in
            self.photoImageView.image = image
            self.addImageButton.isHidden = true
            self.removeImageButton.isHidden = false
        }
    }
    
    @IBAction func removeMedia() {
        photoImageView.image = nil
        addImageButton.isHidden = false
        removeImageButton.isHidden = true
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        addImageButton.back
        photoImageView.contentMode = .scaleAspectFill
        removeImageButton.isHidden = true
    }
}

