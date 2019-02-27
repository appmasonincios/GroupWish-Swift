//
//  ReceivedTYCardsTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 14/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class ReceivedTYCardsTableViewCell: UITableViewCell {

    @IBOutlet weak var cardimage: UIImageView!
    @IBOutlet weak var cardname: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var userimage: ImageViewDesign!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var backView:UIView!
    @IBOutlet weak var message:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
