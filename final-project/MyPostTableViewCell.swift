//
//  MyPostTableViewCell.swift
//  final-project
//
//  Created by Andrew Chiu on 17/03/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit

class MyPostTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
