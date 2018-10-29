//
//  MessageCell.swift
//  Chatr
//
//  Created by Andriana Aivazians on 10/29/18.
//  Copyright © 2018 Andriana Aivazians. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    // UI Elements
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
