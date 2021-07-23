//
//  MessageCell.swift
//  ChattingApp
//
//  Created by 윤경록 on 23/07/2021.
//  Copyright © 2021 윤경록. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var LeftImageView: UIImageView!
    @IBOutlet weak var MessageLabel: UILabel!
    
    @IBOutlet weak var RightImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
