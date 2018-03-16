//
//  MessageDetailTableViewCell.swift
//  final-project
//
//  Created by Andrew Chiu on 15/03/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit

class MessageDetailTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
